import XCTest
@testable import GotchaSlotsIOS

final class BonusGameEvaluatorTests: XCTestCase {
    let bonusGame = SymbolConfig(id: 5, assetName: "bonus", payoutTable: PayoutTable(payoutByHits: [5: 20, 4: 15, 3: 10, 2: 5]))

    func testCountsOnlyBonusSymbolsWithinThePaylineItself() {
        // Payline touches cells [0,1,2,3,4]; two of them are the bonus symbol.
        let cells: [Int: Int] = [0: 5, 1: 5, 2: 0, 3: 0, 4: 0]
        let matrix = ResultMatrix(cells: cells, gridShape: .grid5x3)
        let payline = Payline(id: 0, color: 0, cells: [0, 1, 2, 3, 4])

        let results = BonusGameEvaluator.evaluate(matrix: matrix, paylines: [payline], bonusGameSymbol: bonusGame)
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results[0].hits, 2)
        XCTAssertEqual(results[0].payout, 5) // 2 hits -> 5
    }

    func testProducesOneResultPerPayline_evenNonTriggering() {
        // Ports the "one entry per payline regardless of outcome" convention shared with Strike
        // (CalculatePaylinesPayout indexes by position, so every payline needs an entry).
        let cells: [Int: Int] = [0: 0, 1: 0, 2: 0, 3: 0, 4: 0] // no bonus symbols at all
        let matrix = ResultMatrix(cells: cells, gridShape: .grid5x3)
        let payline = Payline(id: 0, color: 0, cells: [0, 1, 2, 3, 4])

        let results = BonusGameEvaluator.evaluate(matrix: matrix, paylines: [payline], bonusGameSymbol: bonusGame)
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results[0].hits, 0)
        XCTAssertEqual(results[0].payout, 0)
    }
}

final class ScatterEvaluatorTests: XCTestCase {
    let freeSpins = SymbolConfig(id: 6, assetName: "fs", payoutTable: PayoutTable(payoutByHits: [5: 7, 4: 5, 3: 3, 2: 2]))

    func testCountsAcrossTheEntireGrid_notJustOnePayline() {
        // Scatter counts grid-wide, unlike BonusGame's payline-scoped count.
        let cells: [Int: Int] = [0: 6, 5: 6, 10: 6, 1: 0, 2: 0]
        let matrix = ResultMatrix(cells: cells, gridShape: .grid5x3)

        let result = ScatterEvaluator.evaluate(matrix: matrix, symbol: freeSpins)
        XCTAssertEqual(result.hits, 3)
        XCTAssertEqual(result.payout, 3) // 3 hits -> 3
    }

    func testBelowMinimumHits_isNotValuable() {
        let cells: [Int: Int] = [0: 6, 1: 0]
        let matrix = ResultMatrix(cells: cells, gridShape: .grid5x3)
        let result = ScatterEvaluator.evaluate(matrix: matrix, symbol: freeSpins)
        XCTAssertEqual(result.hits, 1)
        XCTAssertFalse(result.isValuable) // freeSpins min hits to pay is 2
    }
}
