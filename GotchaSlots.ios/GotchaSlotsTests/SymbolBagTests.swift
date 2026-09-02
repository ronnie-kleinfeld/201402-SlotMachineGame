import XCTest
@testable import GotchaSlotsIOS

final class SymbolBagTests: XCTestCase {
    // Two normal symbols with equal payoutSum -> equal bag weight.
    let equalA = SymbolConfig(id: 0, assetName: "a", payoutTable: PayoutTable(payoutByHits: [5: 10]))
    let equalB = SymbolConfig(id: 1, assetName: "b", payoutTable: PayoutTable(payoutByHits: [5: 10]))
    let wild = SymbolConfig(id: 2, assetName: "wild", payoutTable: PayoutTable(payoutByHits: [5: 20, 4: 15, 3: 10, 2: 5]))

    func testEqualPayoutSymbols_getEqualBagWeight() {
        let bag = SymbolBag(normalSymbols: [equalA, equalB], wild: wild, factor: 1.0)
        let countA = bag.bag.filter { $0 == equalA.id }.count
        let countB = bag.bag.filter { $0 == equalB.id }.count
        XCTAssertEqual(countA, countB)
    }

    func testHigherPayoutSymbol_getsFewerBagSlots() {
        // rare/high-payout symbol: payoutSum = 100, common/low-payout: payoutSum = 10.
        // ceil(1/max(ratio,0.05))*10 -> high-payout symbol's ratio is large so it gets the
        // minimum slot count (10); low-payout symbol's ratio is small so it gets many more.
        let rare = SymbolConfig(id: 0, assetName: "rare", payoutTable: PayoutTable(payoutByHits: [5: 100]))
        let common = SymbolConfig(id: 1, assetName: "common", payoutTable: PayoutTable(payoutByHits: [5: 10]))
        let bag = SymbolBag(normalSymbols: [rare, common], wild: wild, factor: 1.0)

        let rareCount = bag.bag.filter { $0 == rare.id }.count
        let commonCount = bag.bag.filter { $0 == common.id }.count
        XCTAssertLessThan(rareCount, commonCount)
    }

    func testWildBagShare_matchesSpecialOddsFormula() {
        // Classic's factor = 1 -> WildSymbolData.SpecialOdds = 0.25*factor = 0.25, added AFTER
        // normal symbols so it's 25% of the normal-symbols bag size, per SymbolsData.AddOdds.
        let bag = SymbolBag(normalSymbols: [equalA, equalB], wild: wild, factor: 1.0)
        let normalCount = bag.bag.filter { $0 != wild.id }.count
        let wildCount = bag.bag.filter { $0 == wild.id }.count
        XCTAssertEqual(wildCount, Int(ceil(Double(normalCount) * 0.25)))
    }

    func testRandomID_onlyReturnsConfiguredSymbolIDs() {
        let bag = SymbolBag(normalSymbols: [equalA, equalB], wild: wild, factor: 1.0)
        let validIDs: Set<Int> = [equalA.id, equalB.id, wild.id]
        for _ in 0..<1000 {
            XCTAssertTrue(validIDs.contains(bag.randomID))
        }
    }

    func testRandomNormalID_neverReturnsWild() {
        let bag = SymbolBag(normalSymbols: [equalA, equalB], wild: wild, factor: 1.0)
        for _ in 0..<1000 {
            XCTAssertNotEqual(bag.randomNormalID, wild.id)
        }
    }
}
