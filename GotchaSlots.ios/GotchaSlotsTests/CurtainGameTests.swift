import XCTest
@testable import GotchaSlotsIOS

final class CurtainGameTests: XCTestCase {
    /// A level with a controllable, non-random outcome for deterministic testing — CurtainItem's
    /// own initializer randomizes payout/isFailure, so tests that need a KNOWN outcome build the
    /// level directly rather than going through HolidayCurtainConfig.
    func makeLevel(id: Int, items: [(payout: Int, isFailure: Bool)], selectiveItemsCount: Int = 1) -> CurtainLevel {
        CurtainLevel(
            id: id, mapMessage: "m", tickerMessage: "t",
            items: items.enumerated().map { i, spec in
                CurtainItem(id: i, payout: spec.payout, isFailure: spec.isFailure)
            },
            selectiveItemsCount: selectiveItemsCount
        )
    }

    func testPickingANonFailureItem_clearsTheLevel_whenSelectiveCountReached() {
        let level = makeLevel(id: 0, items: [(3, false), (5, true)])
        var state = CurtainGameState(levels: [level])
        let outcome = state.pick(itemID: 0) // the non-failure item
        XCTAssertEqual(outcome, .allLevelsCleared) // only 1 level, cleared -> whole game done
        XCTAssertTrue(state.isOver)
        XCTAssertEqual(state.chipsWon(selectedBetChips: 2.0), 6) // payout 3 * bet 2
    }

    func testPickingAFailureItem_endsTheGameImmediately() {
        let level = makeLevel(id: 0, items: [(3, false), (5, true)])
        var state = CurtainGameState(levels: [level])
        let outcome = state.pick(itemID: 1) // the failure item
        XCTAssertEqual(outcome, .failed)
        XCTAssertTrue(state.isOver)
        XCTAssertEqual(state.chipsWon(selectedBetChips: 2.0), 0) // failure item pays nothing
    }

    func testClearingALevel_advancesToTheNextOne_keepsPriorWinnings() {
        let level0 = makeLevel(id: 0, items: [(4, false), (5, true)])
        let level1 = makeLevel(id: 1, items: [(2, true), (7, false)])
        var state = CurtainGameState(levels: [level0, level1])

        XCTAssertEqual(state.pick(itemID: 0), .levelCleared) // level0's non-failure item
        XCTAssertFalse(state.isOver)
        XCTAssertEqual(state.currentLevel?.id, 1)

        XCTAssertEqual(state.pick(itemID: 1), .allLevelsCleared) // level1's non-failure item (id 1)
        XCTAssertTrue(state.isOver)
        XCTAssertEqual(state.chipsWon(selectedBetChips: 1.0), 11) // 4 + 7
    }

    func testFailingOnASecondLevel_stillKeepsFirstLevelWinnings() {
        let level0 = makeLevel(id: 0, items: [(4, false), (5, true)])
        let level1 = makeLevel(id: 1, items: [(2, true), (7, false)])
        var state = CurtainGameState(levels: [level0, level1])

        _ = state.pick(itemID: 0) // clears level 0, +4
        let outcome = state.pick(itemID: 0) // level1's failure item (id 0 in level1)
        XCTAssertEqual(outcome, .failed)
        XCTAssertEqual(state.chipsWon(selectedBetChips: 1.0), 4) // only level0's win survives
    }

    func testHolidayCurtainConfig_hasFourLevelsWithExpectedItemCounts() {
        let levels = HolidayCurtainConfig.makeLevels()
        XCTAssertEqual(levels.count, 4)
        XCTAssertEqual(levels.map(\.items.count), [5, 6, 6, 4])
        XCTAssertTrue(levels.allSatisfy { $0.selectiveItemsCount == 1 })
    }

    func testCurtainItem_payoutIsAlwaysOneToNine() {
        for _ in 0..<200 {
            let item = CurtainItem(id: 0)
            XCTAssertTrue((1...9).contains(item.payout))
        }
    }
}
