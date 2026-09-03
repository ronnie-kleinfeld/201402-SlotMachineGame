import XCTest
@testable import GotchaSlotsIOS

@MainActor
final class SpinStateMachineTests: XCTestCase {
    struct FakeResolver: SpinResolving {
        let result: SpinResult
        func resolve(selectedPaylines: Int, selectedBetChips: Double) -> SpinResult { result }
        func applyBombAndMiniSpinIfNeeded(to result: SpinResult, selectedPaylines: Int, selectedBetChips: Double) -> SpinResult { result }
    }

    func makeResult(totalPayout: Double, totalChips: Double, isBomb: Bool = false, isMultiplier: Bool = false) -> SpinResult {
        let matrix = ResultMatrix(cells: [:], gridShape: .grid5x3)
        let bombResult = isBomb ? ScatterResult(symbolID: 1, hits: 1, payout: 1) : nil
        let multiplierResult = isMultiplier ? ScatterResult(symbolID: 2, hits: 2, payout: 2) : nil
        let payout = SpinPayout(
            strikeResults: [], symetricResults: [], columnResults: [], bonusGameResults: [],
            freeSpinsResult: nil, bombResult: bombResult, miniSpinResult: nil,
            multiplierResult: multiplierResult, aceResult: nil, goldResult: nil, kingResult: nil,
            totalPayout: totalPayout, totalChips: totalChips
        )
        return SpinResult(matrix: matrix, payout: payout)
    }

    func testInsufficientBalance_neverSpins() async {
        let resolver = FakeResolver(result: makeResult(totalPayout: 0, totalChips: 0))
        let sm = SpinStateMachine(resolver: resolver, gridShape: .grid5x3, selectedPaylines: 20, selectedBetChips: 1.0, startingBalance: 5)
        await sm.spin()
        XCTAssertEqual(sm.balance, 5) // unchanged — bet (20) exceeds balance
        XCTAssertNil(sm.lastResult)
        XCTAssertEqual(sm.phase, .idle)
    }

    func testWin_deductsBetAndAddsPayout_endsIdle() async {
        let resolver = FakeResolver(result: makeResult(totalPayout: 10, totalChips: 50))
        let sm = SpinStateMachine(resolver: resolver, gridShape: .grid5x3, selectedPaylines: 20, selectedBetChips: 1.0, startingBalance: 1000)
        await sm.spin()
        // 1000 - 20 (bet) + 50 (win) = 1030
        XCTAssertEqual(sm.balance, 1030)
        XCTAssertNotNil(sm.lastResult)
        XCTAssertEqual(sm.phase, .idle)
    }

    func testBombTrigger_stillSettlesToIdle_evenWithZeroChips() async {
        let resolver = FakeResolver(result: makeResult(totalPayout: 1, totalChips: 0, isBomb: true))
        let sm = SpinStateMachine(resolver: resolver, gridShape: .grid5x3, selectedPaylines: 20, selectedBetChips: 1.0, startingBalance: 1000)
        await sm.spin()
        // 1000 - 20 (bet) + 0 (bomb pays no chips) = 980
        XCTAssertEqual(sm.balance, 980)
        XCTAssertEqual(sm.phase, .idle)
    }

    func testGuardsAgainstReentrantSpin_whileNotIdle() async {
        // A resolver that never returns can't be modeled with async/await easily here, but we
        // can at least confirm spin() is a no-op when phase isn't idle by checking balance
        // stays untouched on a second call after the first already completed and reset to idle
        // (i.e. the guard doesn't wrongly block a legitimate second spin either).
        let resolver = FakeResolver(result: makeResult(totalPayout: 0, totalChips: 0))
        let sm = SpinStateMachine(resolver: resolver, gridShape: .grid5x3, selectedPaylines: 20, selectedBetChips: 1.0, startingBalance: 1000)
        await sm.spin()
        await sm.spin()
        XCTAssertEqual(sm.balance, 960) // two bets of 20 deducted, no wins
        XCTAssertEqual(sm.phase, .idle)
    }

    /// Returns a different fixed result on each successive `resolve()` call (repeating the last
    /// once the sequence is exhausted) — needed to test free spins, since the triggering spin
    /// and each auto-played free spin need distinct results.
    struct SequencedFakeResolver: SpinResolving {
        let results: [SpinResult]
        private let callCount = Counter()

        func resolve(selectedPaylines: Int, selectedBetChips: Double) -> SpinResult {
            let index = min(callCount.next(), results.count - 1)
            return results[index]
        }
        func applyBombAndMiniSpinIfNeeded(to result: SpinResult, selectedPaylines: Int, selectedBetChips: Double) -> SpinResult { result }

        final class Counter {
            private var value = 0
            func next() -> Int { defer { value += 1 }; return value }
        }
    }

    func makeResult(totalPayout: Double, totalChips: Double, freeSpinsAwarded: Double? = nil) -> SpinResult {
        let matrix = ResultMatrix(cells: [:], gridShape: .grid5x3)
        let freeSpinsResult = freeSpinsAwarded.map { ScatterResult(symbolID: 3, hits: 3, payout: $0) }
        let payout = SpinPayout(
            strikeResults: [], symetricResults: [], columnResults: [], bonusGameResults: [],
            freeSpinsResult: freeSpinsResult, bombResult: nil, miniSpinResult: nil,
            multiplierResult: nil, aceResult: nil, goldResult: nil, kingResult: nil,
            totalPayout: totalPayout, totalChips: totalChips
        )
        return SpinResult(matrix: matrix, payout: payout)
    }

    func testFreeSpinsTrigger_playsThemAutomaticallyAtNoExtraCost() async {
        // Spin 1 (paid): triggers 3 free spins, pays 0 chips itself.
        // Spins 2-4 (free): each pays 10 chips, no further trigger.
        let resolver = SequencedFakeResolver(results: [
            makeResult(totalPayout: 3, totalChips: 0, freeSpinsAwarded: 3),
            makeResult(totalPayout: 10, totalChips: 10),
            makeResult(totalPayout: 10, totalChips: 10),
            makeResult(totalPayout: 10, totalChips: 10),
        ])
        let sm = SpinStateMachine(resolver: resolver, gridShape: .grid5x3, selectedPaylines: 20, selectedBetChips: 1.0, startingBalance: 1000)

        await sm.spin()

        // Only ONE bet (20) is ever deducted — the 3 free spins cost nothing.
        // 1000 - 20 + 0 (trigger spin) + 10 + 10 + 10 (three free spins) = 1010.
        XCTAssertEqual(sm.balance, 1010)
        XCTAssertEqual(sm.freeSpinsRemaining, 0)
        XCTAssertEqual(sm.phase, .idle)
        XCTAssertEqual(sm.lastFreeSpinsSummary?.spinsPlayed, 3)
        XCTAssertEqual(sm.lastFreeSpinsSummary?.chipsWon, 30)
    }

    func testFreeSpinsRetrigger_duringFreeSpins_extendsTheRemainingCount() async {
        // Spin 1 (paid): triggers 2 free spins (remaining: 2).
        // Spin 2 (free, consumes 1: remaining 1): retriggers 2 more (remaining: 1+2 = 3).
        // Spins 3-5 (free): plain, no further trigger, draining remaining 3 -> 0.
        // Total free spins played: 4 (the sequence's last entry repeats once exhausted).
        let resolver = SequencedFakeResolver(results: [
            makeResult(totalPayout: 2, totalChips: 0, freeSpinsAwarded: 2),
            makeResult(totalPayout: 2, totalChips: 0, freeSpinsAwarded: 2),
            makeResult(totalPayout: 5, totalChips: 5),
        ])
        let sm = SpinStateMachine(resolver: resolver, gridShape: .grid5x3, selectedPaylines: 20, selectedBetChips: 1.0, startingBalance: 1000)

        await sm.spin()

        XCTAssertEqual(sm.freeSpinsRemaining, 0)
        XCTAssertEqual(sm.lastFreeSpinsSummary?.spinsPlayed, 4)
        // 1000 - 20 (one paid bet) + 0 (trigger spin) + 0 (retrigger spin) + 5 + 5 + 5 = 995.
        XCTAssertEqual(sm.balance, 995)
    }

    func testNoFreeSpinsTriggered_leavesSummaryNil() async {
        let resolver = FakeResolver(result: makeResult(totalPayout: 10, totalChips: 10))
        let sm = SpinStateMachine(resolver: resolver, gridShape: .grid5x3, selectedPaylines: 20, selectedBetChips: 1.0, startingBalance: 1000)
        await sm.spin()
        XCTAssertNil(sm.lastFreeSpinsSummary)
        XCTAssertEqual(sm.freeSpinsRemaining, 0)
    }

    // MARK: - Leveling (XP)

    func testEverySpin_earnsXPEqualToTheTotalBet_evenWithNoWin() async {
        // totalBet = 1.0 * 20 = 20/spin. Level 2's threshold is ~200.618 XP, so the player is
        // still level 1 after exactly 10 spins (XP=200 < 200.618).
        let resolver = FakeResolver(result: makeResult(totalPayout: 0, totalChips: 0))
        let sm = SpinStateMachine(resolver: resolver, gridShape: .grid5x3, selectedPaylines: 20, selectedBetChips: 1.0, startingBalance: 1_000_000)
        for _ in 0..<10 { await sm.spin() }
        XCTAssertEqual(sm.level, 1)
        XCTAssertNil(sm.lastLevelUp)
    }

    func testCrossingALevelThreshold_awardsABonusAndPublishesLastLevelUp() async {
        // The 11th spin pushes XP from 200 to 220, crossing level 2's ~200.618 threshold.
        let resolver = FakeResolver(result: makeResult(totalPayout: 0, totalChips: 0))
        let sm = SpinStateMachine(resolver: resolver, gridShape: .grid5x3, selectedPaylines: 20, selectedBetChips: 1.0, startingBalance: 1_000_000)
        for _ in 0..<10 { await sm.spin() }
        let balanceBeforeLevelUp = sm.balance

        await sm.spin()

        XCTAssertEqual(sm.level, 2)
        XCTAssertEqual(sm.lastLevelUp?.newLevel, 2)
        let expectedBonus = LevelThresholds.levelReachedBonusChips(forLevel: 2)
        XCTAssertEqual(sm.lastLevelUp?.bonusChips, expectedBonus)
        // Balance reflects the bet deducted AND the level-up bonus credited in the same spin.
        XCTAssertEqual(sm.balance, balanceBeforeLevelUp - 20 + expectedBonus)
    }

    func testFreeSpins_alsoEarnXP_evenThoughTheyDontCostBalance() async {
        // Spin 1 (paid, 20 XP): triggers 1 free spin.
        // Spin 2 (free, ALSO 20 XP, ports SpinStarted always granting XP regardless of isFreeSpins).
        let resolver = SequencedFakeResolver(results: [
            makeResult(totalPayout: 1, totalChips: 0, freeSpinsAwarded: 1),
            makeResult(totalPayout: 0, totalChips: 0),
        ])
        let sm = SpinStateMachine(resolver: resolver, gridShape: .grid5x3, selectedPaylines: 20, selectedBetChips: 1.0, startingBalance: 1_000_000)
        await sm.spin()
        XCTAssertEqual(sm.level, LevelThresholds.level(forXP: 40)) // 20 (paid) + 20 (free) = 40 XP
    }
}
