import Foundation

/// Ports the shape of SlotsMachineController's callback chain as an explicit enum, rather than
/// a sequence of private methods each calling the next. Order matches the original exactly:
/// DoBomb -> DoMiniSpin -> DoCollectibles -> DoColumn -> DoSymetric -> DoStrike -> DoWins ->
/// DoFiveInARow -> DoFourInARow -> DoBonusGame -> DoMultiplier -> DoFreeSpins -> DoWinToBalance.
/// The original skips straight to the next step when a given check isn't valuable; this port
/// does the same — `spin()` only visits (publishes) the phases whose trigger actually fired.
///
/// Phase 3 wires trigger *detection* through every step; it deliberately does NOT implement the
/// bespoke gameplay each trigger unlocks (a bomb clearing/cascading symbols, a mini-spin re-roll,
/// the bonus-game mini-game itself, a free-spins repeat-spin loop) — those are real feature work
/// with their own animation/state needs, scoped to later phases (bonus games are Phase 4;
/// free-spins repeat-spin and bomb/mini-spin cascade mechanics aren't itemized in the plan yet
/// and should be scoped explicitly before building). A UI observing `phase` can already react to
/// "a bonus game should start now" etc — the mechanics behind that reaction are what's deferred.
enum SpinPhase: Equatable {
    case idle
    case spinning
    case revealing
    case bomb
    case miniSpin
    case collectibles
    case column
    case symetric
    case strike
    case fiveInARow
    case fourInARow
    case bonusGame
    case multiplier
    case freeSpins
    case winToBalance
    case settling
}

struct FreeSpinsSummary {
    let spinsPlayed: Int
    let chipsWon: Double
}

struct LevelUpSummary {
    let newLevel: Int
    let bonusChips: Double
}

/// Ports SlotsMachineController's Init→DoIdle→DoSpin→...→DoIdle chain as an async sequence
/// instead of a chain of completion-callback methods.
@MainActor
final class SpinStateMachine: ObservableObject {
    @Published private(set) var phase: SpinPhase = .idle
    @Published private(set) var lastResult: SpinResult?
    @Published private(set) var balance: Double
    /// XP-derived, mirroring WalletState.level — see LevelThresholds.
    var level: Int { LevelThresholds.level(forXP: xp) }
    /// Set when DoBonusGame's trigger fires and a bonus-game kind is configured; a presentation
    /// layer observes this to show the minigame UI, then calls `pickCurtainItem`/
    /// `guessHigherLower` as the player plays, and the state machine settles it (adding its
    /// chips to balance, ports BaseBonusGameEngine's DoBonusGameComplete -> CalculateChipsWon)
    /// once the minigame reports `isOver`.
    @Published private(set) var activeBonusGame: ActiveBonusGame?
    /// Ports SlotsMachineSessionData's FreeSpinsPendingCount (WonCount - PlayedCount): how many
    /// more free spins are owed. `spin()` auto-plays through these with no balance cost (ports
    /// DoFreeSpinsPendingOrWon's DoSpin(false) auto-continuation) before returning to `.idle`.
    @Published private(set) var freeSpinsRemaining: Int = 0
    /// Set once a free-spins sequence this `spin()` call triggered has fully drained, so the
    /// presentation layer can show one summary instead of only the last individual spin's result.
    @Published private(set) var lastFreeSpinsSummary: FreeSpinsSummary?
    /// Ports WalletSessionData's Level as an XP-derived value the presentation layer can react
    /// to (e.g. a "Level Up!" toast) — set once per `spin()` call if any of its real/free spins
    /// crossed a level threshold (see `addXP`). The lobby itself doesn't need a push notification
    /// for this: it re-reads `walletStore.state.level` fresh every time it's shown.
    @Published private(set) var lastLevelUp: LevelUpSummary?

    private var freeSpinsSequenceCount = 0
    private var freeSpinsSequenceChips = 0.0
    private var levelUpThisSequence: LevelUpSummary?
    /// Lifetime chips wagered — mirrors WalletState.xp the same way `balance` mirrors
    /// WalletState.balance (in-memory always, persisted when a walletStore is present).
    private var xp: Double = 0

    private let resolver: SpinResolving
    private let gridShape: GridShape
    private let bonusGameKind: BonusGameKind?
    private let selectedPaylines: Int
    private let selectedBetChips: Double
    /// Ports WalletSessionData's persistence — nil (the default) keeps balance purely in-memory,
    /// which is what every pre-Phase-5 test relies on. When present, `balance` is seeded from
    /// (and every change is written back to) the Keychain-backed store instead of
    /// `startingBalance`.
    private let walletStore: KeychainStore<WalletState>?

    init(
        resolver: SpinResolving, gridShape: GridShape, bonusGameKind: BonusGameKind? = nil,
        selectedPaylines: Int, selectedBetChips: Double, startingBalance: Double,
        walletStore: KeychainStore<WalletState>? = nil
    ) {
        self.resolver = resolver
        self.gridShape = gridShape
        self.bonusGameKind = bonusGameKind
        self.selectedPaylines = selectedPaylines
        self.selectedBetChips = selectedBetChips
        self.walletStore = walletStore
        self.balance = walletStore?.state.balance ?? startingBalance
        self.xp = walletStore?.state.xp ?? 0
    }

    private func persistBalance() {
        walletStore?.update { $0.balance = balance; $0.xp = xp }
    }

    /// Ports WalletSessionData.SpinStarted's `XP += xp` (xp == the total bet, granted for BOTH
    /// real and free spins, unlike the balance deduction which only applies to real spins) plus
    /// the XP setter's level-up check. AS3 queues a popup and defers `CollectLevelUpBonus` to
    /// when the player dismisses it; this port simplifies that to crediting the bonus immediately
    /// and surfacing the fact via `lastLevelUp`, matching how Bomb/MiniSpin/FreeSpins already
    /// skip intermediate popup/animation steps in favor of presenting the settled result.
    private func addXP(_ amount: Double) {
        let previousLevel = LevelThresholds.level(forXP: xp)
        xp += amount
        let newLevel = LevelThresholds.level(forXP: xp)
        guard newLevel > previousLevel else { return }

        let bonus = LevelThresholds.levelReachedBonusChips(forLevel: newLevel)
        balance += bonus
        levelUpThisSequence = LevelUpSummary(
            newLevel: newLevel,
            bonusChips: (levelUpThisSequence?.bonusChips ?? 0) + bonus
        )
    }

    /// Ports DoSpin through DoWinToBalance for one PAID spin, then plays out any free spins
    /// this triggered via `playPendingFreeSpins()` before settling back to `.idle` — matching
    /// DoFreeSpinsPendingOrWon's auto-continuation, which the original never returns control to
    /// the player from until every pending free spin (including retriggers) is exhausted.
    func spin() async {
        guard phase == .idle else { return }
        let totalBet = selectedBetChips * Double(selectedPaylines)
        guard balance >= totalBet else { return }

        lastFreeSpinsSummary = nil
        freeSpinsSequenceCount = 0
        freeSpinsSequenceChips = 0
        lastLevelUp = nil
        levelUpThisSequence = nil

        await performSpin(isFreeSpin: false)
        await playPendingFreeSpins()

        lastLevelUp = levelUpThisSequence
        phase = .settling
        phase = .idle
    }

    /// Ports DoSpin through DoWinToBalance: resolves the outcome (re-evaluating against a
    /// mutated board if Bomb/MiniSpin fired) and walks the presentation sequence in the original
    /// order, visiting only the phases whose trigger fired. Reel animation timing is the
    /// presentation layer's job; this only owns the data-side phase transitions.
    private func performSpin(isFreeSpin: Bool) async {
        let totalBet = selectedBetChips * Double(selectedPaylines)
        if isFreeSpin {
            // Ports WalletSessionData.SpinStarted(isFreeSpins:true) never touching Balance —
            // free spins use the same bet/paylines as the triggering spin but cost nothing.
            freeSpinsRemaining -= 1
        } else {
            guard balance >= totalBet else { return }
            balance -= totalBet
            persistBalance()
        }
        // Ports SpinStarted's `XP += xp` — granted for every spin, free or paid alike (matches
        // AS3 passing TotalBetChips as both the `chips` and `xp` arguments regardless of
        // isFreeSpins).
        addXP(totalBet)
        phase = .spinning

        var result = resolver.resolve(selectedPaylines: selectedPaylines, selectedBetChips: selectedBetChips)
        phase = .revealing

        if result.payout.isBombTriggered { phase = .bomb }
        if result.payout.isMiniSpinTriggered { phase = .miniSpin }
        if result.payout.isBombTriggered || result.payout.isMiniSpinTriggered {
            result = resolver.applyBombAndMiniSpinIfNeeded(
                to: result, selectedPaylines: selectedPaylines, selectedBetChips: selectedBetChips
            )
        }
        lastResult = result
        let payout = result.payout

        if payout.aceResult != nil || payout.goldResult != nil || payout.kingResult != nil { phase = .collectibles }
        if !payout.columnResults.isEmpty { phase = .column }
        if !payout.symetricResults.isEmpty { phase = .symetric }
        if payout.strikeResults.contains(where: { $0.isValuable }) { phase = .strike }
        if payout.isFiveInARow(gridShape: gridShape) { phase = .fiveInARow }
        if payout.isFourInARow(gridShape: gridShape) { phase = .fourInARow }
        if payout.isBonusGameTriggered {
            phase = .bonusGame
            if let bonusGameKind {
                activeBonusGame = ActiveBonusGame.make(kind: bonusGameKind)
            }
        }
        if payout.isMultiplierTriggered { phase = .multiplier }
        if payout.isFreeSpinsTriggered {
            phase = .freeSpins
            // Ports FreeSpinsPresentation's FreeSpinsCollectCount(_valuatorsHandler.FreeSpins.
            // Payout) — despite the symbol's descriptive paytable note text implying a random
            // range, the actual call site passes the scatter valuator's own deterministic
            // PayoutByHits(hits) result straight through with no randomization; ScatterResult.
            // payout already IS that value, truncated to Int the same way AS3's implicit
            // Number->int coercion does when it's passed into the `wonCount:int` parameter.
            if let awarded = payout.freeSpinsResult.map({ Int($0.payout) }), awarded > 0 {
                freeSpinsRemaining += awarded
            }
        }

        phase = .winToBalance
        balance += payout.totalChips
        persistBalance()
    }

    /// Ports DoFreeSpinsPendingOrWon's DoSpin(false) loop: keeps auto-playing free spins until
    /// none remain, pausing if a bonus game triggers mid-sequence (a fresh grid on ANY free spin
    /// can independently hit the bonus-game trigger, same as a paid spin) — `settleBonusGameIfOver`
    /// resumes this once that's settled. Accumulates across a pause/resume so the eventual
    /// summary reflects the whole sequence, not just the leg after the bonus game.
    private func playPendingFreeSpins() async {
        guard freeSpinsRemaining > 0, activeBonusGame == nil else { return }
        while freeSpinsRemaining > 0 {
            let balanceBefore = balance
            await performSpin(isFreeSpin: true)
            freeSpinsSequenceCount += 1
            freeSpinsSequenceChips += balance - balanceBefore
            if activeBonusGame != nil { return }
        }
        lastFreeSpinsSummary = FreeSpinsSummary(spinsPlayed: freeSpinsSequenceCount, chipsWon: freeSpinsSequenceChips)
    }

    /// Ports LevelBox.onItemClicked via CurtainGameState.pick, then settles the bonus game
    /// (BaseBonusGameEngine.DoBonusGameComplete -> CalculateChipsWon -> added to wallet) once
    /// it reports over — mirrors AS3's flow of the mini-game's own Chips being credited
    /// separately from, and after, the spin's own totalChips (already added in `performSpin`).
    func pickCurtainItem(_ itemID: Int) async {
        guard case .curtain(var state) = activeBonusGame else { return }
        _ = state.pick(itemID: itemID)
        activeBonusGame = .curtain(state)
        await settleBonusGameIfOver()
    }

    /// Ports HigherLowerEngine.onLowerClick/onHigherClick via HigherLowerGameState.guess.
    func guessHigherLower(_ guess: HigherLowerGuess) async {
        guard case .higherLower(var state) = activeBonusGame else { return }
        _ = state.guess(guess)
        activeBonusGame = .higherLower(state)
        await settleBonusGameIfOver()
    }

    private func settleBonusGameIfOver() async {
        guard let activeBonusGame, activeBonusGame.isOver else { return }
        balance += activeBonusGame.chipsWon(selectedBetChips: selectedBetChips)
        persistBalance()
        self.activeBonusGame = nil
        await playPendingFreeSpins()
        // `spin()`'s own tail already published whatever had accumulated up to the point this
        // bonus game paused the free-spins loop; resuming it here can accumulate further
        // (another level crossed, more spins played), so republish after each resume too —
        // spin() itself has already returned by the time a bonus game settles.
        lastLevelUp = levelUpThisSequence
    }
}
