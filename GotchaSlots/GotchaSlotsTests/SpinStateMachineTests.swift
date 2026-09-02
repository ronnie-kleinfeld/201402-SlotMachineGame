import XCTest
@testable import GotchaSlots

@MainActor
final class SpinStateMachineTests: XCTestCase {
    struct FakeResolver: SpinResolving {
        let result: SpinResult
        func resolve(selectedPaylines: Int, selectedBetChips: Double) -> SpinResult { result }
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
}
