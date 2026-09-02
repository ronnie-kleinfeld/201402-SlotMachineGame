import XCTest
@testable import GotchaSlotsIOS

final class PayoutTableTests: XCTestCase {
    // Symbol_01 from classic_5x3.json: 5:22, 4:11, 3:5, 2:0 (1-in-a-row implicitly 0, ported
    // from NormalSymbolData always passing oneInARowPayout=0).
    let symbol01 = PayoutTable(payoutByHits: [5: 22, 4: 11, 3: 5, 2: 0])

    func testMinimumHitsToPayout_skipsZeroTiers() {
        // twoInARow is configured but 0, so the minimum paying tier is 3, matching
        // BaseSymbolData.MinimumHitsToPayout scanning 1->5 for the first *nonzero* payout.
        XCTAssertEqual(symbol01.minimumHitsToPayout, 3)
    }

    func testPayout_belowMinimumHits_isZero() {
        XCTAssertEqual(symbol01.payout(forHits: 2), 0)
        XCTAssertEqual(symbol01.payout(forHits: 1), 0)
        XCTAssertEqual(symbol01.payout(forHits: 0), 0)
    }

    func testPayout_atOrAboveMinimumHits_matchesConfiguredTier() {
        XCTAssertEqual(symbol01.payout(forHits: 3), 5)
        XCTAssertEqual(symbol01.payout(forHits: 4), 11)
        XCTAssertEqual(symbol01.payout(forHits: 5), 22)
    }

    func testPayoutSum_isFlooredAtOne() {
        let table = PayoutTable(payoutByHits: [:])
        XCTAssertEqual(table.payoutSum, 1)
    }

    func testPayoutSum_sumsAllConfiguredTiers() {
        // 22 + 11 + 5 + 0 = 38
        XCTAssertEqual(symbol01.payoutSum, 38)
    }

    func testWildSymbol_allTiersPayFromOneHit() {
        // Wild: 20/15/10/5, no zero tier, so minimum hits to payout is 2 (2-in-a-row already pays).
        let wild = PayoutTable(payoutByHits: [5: 20, 4: 15, 3: 10, 2: 5])
        XCTAssertEqual(wild.minimumHitsToPayout, 2)
        XCTAssertEqual(wild.payout(forHits: 2), 5)
        XCTAssertEqual(wild.payout(forHits: 1), 0)
    }
}
