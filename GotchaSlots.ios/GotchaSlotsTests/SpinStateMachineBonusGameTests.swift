import XCTest
@testable import GotchaSlotsIOS

@MainActor
final class SpinStateMachineBonusGameTests: XCTestCase {
    struct FakeResolver: SpinResolving {
        let result: SpinResult
        func resolve(selectedPaylines: Int, selectedBetChips: Double) -> SpinResult { result }
        func applyBombAndMiniSpinIfNeeded(to result: SpinResult, selectedPaylines: Int, selectedBetChips: Double) -> SpinResult { result }
    }

    func makeBonusTriggeringResult() -> SpinResult {
        let matrix = ResultMatrix(cells: [:], gridShape: .grid5x3)
        let triggeringLine = BonusGameResult(payline: Payline(id: 0, color: 0, cells: []), hits: 3, payout: 5)
        let payout = SpinPayout(
            strikeResults: [], symetricResults: [], columnResults: [], bonusGameResults: [triggeringLine],
            freeSpinsResult: nil, bombResult: nil, miniSpinResult: nil, multiplierResult: nil,
            aceResult: nil, goldResult: nil, kingResult: nil,
            totalPayout: 5, totalChips: 5
        )
        return SpinResult(matrix: matrix, payout: payout)
    }

    func testBonusGameTrigger_constructsTheConfiguredKind() async {
        let resolver = FakeResolver(result: makeBonusTriggeringResult())
        let sm = SpinStateMachine(
            resolver: resolver, gridShape: .grid5x3, bonusGameKind: .curtain("holiday"),
            selectedPaylines: 20, selectedBetChips: 1.0, startingBalance: 1000
        )
        await sm.spin()

        guard case .curtain = sm.activeBonusGame else {
            XCTFail("expected a curtain bonus game to be active")
            return
        }
    }

    func testNoBonusGameKindConfigured_triggerStillDetectedButNoGameConstructed() async {
        let resolver = FakeResolver(result: makeBonusTriggeringResult())
        let sm = SpinStateMachine(
            resolver: resolver, gridShape: .grid5x3, bonusGameKind: nil,
            selectedPaylines: 20, selectedBetChips: 1.0, startingBalance: 1000
        )
        await sm.spin()
        XCTAssertNil(sm.activeBonusGame)
    }

    func testPlayingTheCurtainGameToCompletion_addsItsChipsToBalance() async {
        let resolver = FakeResolver(result: makeBonusTriggeringResult())
        let sm = SpinStateMachine(
            resolver: resolver, gridShape: .grid5x3, bonusGameKind: .curtain("holiday"),
            selectedPaylines: 20, selectedBetChips: 1.0, startingBalance: 1000
        )
        await sm.spin()
        // Balance after the spin itself: 1000 - 20 (bet) + 5 (bonus trigger line payout) = 985.
        let balanceBeforeBonusPlay = sm.balance
        XCTAssertEqual(balanceBeforeBonusPlay, 985)
        XCTAssertNotNil(sm.activeBonusGame)

        // Play the curtain game to completion (pick items until it resolves, win or lose).
        var guard_ = 0
        while sm.activeBonusGame != nil, guard_ < 100 {
            guard case .curtain(let state) = sm.activeBonusGame, let level = state.currentLevel,
                  let firstUnselected = level.items.first(where: { !$0.isSelected })
            else { break }
            await sm.pickCurtainItem(firstUnselected.id)
            guard_ += 1
        }

        XCTAssertNil(sm.activeBonusGame) // settled
        // Balance only ever goes up or stays the same from the bonus game (failure items pay 0,
        // never negative), so it must be >= what it was before playing.
        XCTAssertGreaterThanOrEqual(sm.balance, balanceBeforeBonusPlay)
    }
}
