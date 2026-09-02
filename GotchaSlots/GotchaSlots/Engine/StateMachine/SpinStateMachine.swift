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

/// Ports SlotsMachineController's Init→DoIdle→DoSpin→...→DoIdle chain as an async sequence
/// instead of a chain of completion-callback methods.
@MainActor
final class SpinStateMachine: ObservableObject {
    @Published private(set) var phase: SpinPhase = .idle
    @Published private(set) var lastResult: SpinResult?
    @Published private(set) var balance: Double

    private let resolver: SpinResolving
    private let gridShape: GridShape
    private let selectedPaylines: Int
    private let selectedBetChips: Double

    init(resolver: SpinResolving, gridShape: GridShape, selectedPaylines: Int, selectedBetChips: Double, startingBalance: Double) {
        self.resolver = resolver
        self.gridShape = gridShape
        self.selectedPaylines = selectedPaylines
        self.selectedBetChips = selectedBetChips
        self.balance = startingBalance
    }

    /// Ports DoSpin through DoWinToBalance: validates balance, resolves the outcome, and walks
    /// the presentation sequence in the original order, visiting only the phases whose trigger
    /// fired. Reel animation timing is the presentation layer's job (Phase 1 step 9); this only
    /// owns the data-side phase transitions.
    func spin() async {
        guard phase == .idle else { return }
        let totalBet = selectedBetChips * Double(selectedPaylines)
        guard balance >= totalBet else { return }

        balance -= totalBet
        phase = .spinning

        let result = resolver.resolve(selectedPaylines: selectedPaylines, selectedBetChips: selectedBetChips)
        lastResult = result
        let payout = result.payout

        phase = .revealing

        if payout.isBombTriggered { phase = .bomb }
        if payout.isMiniSpinTriggered { phase = .miniSpin }
        if payout.aceResult != nil || payout.goldResult != nil || payout.kingResult != nil { phase = .collectibles }
        if !payout.columnResults.isEmpty { phase = .column }
        if !payout.symetricResults.isEmpty { phase = .symetric }
        if payout.strikeResults.contains(where: { $0.isValuable }) { phase = .strike }
        if payout.isFiveInARow(gridShape: gridShape) { phase = .fiveInARow }
        if payout.isFourInARow(gridShape: gridShape) { phase = .fourInARow }
        if payout.isBonusGameTriggered { phase = .bonusGame }
        if payout.isMultiplierTriggered { phase = .multiplier }
        if payout.isFreeSpinsTriggered { phase = .freeSpins }

        phase = .winToBalance
        balance += payout.totalChips

        phase = .settling
        phase = .idle
    }
}
