import XCTest
@testable import GotchaSlots

final class StrikeEvaluatorTests: XCTestCase {
    // symbol 0: 5:22,4:11,3:5,2:0 (min 3 hits to pay)
    // symbol 1: 5:16,4:10,3:5,2:0 (min 3 hits to pay)
    // wild:     5:20,4:15,3:10,2:5 (min 2 hits to pay)
    let symbol0 = SymbolConfig(id: 0, assetName: "s0", payoutTable: PayoutTable(payoutByHits: [5: 22, 4: 11, 3: 5, 2: 0]))
    let symbol1 = SymbolConfig(id: 1, assetName: "s1", payoutTable: PayoutTable(payoutByHits: [5: 16, 4: 10, 3: 5, 2: 0]))
    let wild = SymbolConfig(id: 2, assetName: "wild", payoutTable: PayoutTable(payoutByHits: [5: 20, 4: 15, 3: 10, 2: 5]))

    lazy var bag = SymbolBag(normalSymbols: [symbol0, symbol1], wild: wild, factor: 1.0)

    // A single horizontal 5-cell payline over row 0 of a 5x3 grid (cells 0..4).
    let payline = Payline(id: 0, color: 0, cells: [0, 1, 2, 3, 4])

    func matrix(_ row: [Int]) -> ResultMatrix {
        precondition(row.count == 5)
        var cells: [Int: Int] = [:]
        for (i, id) in row.enumerated() { cells[i] = id }
        return ResultMatrix(cells: cells, gridShape: .grid5x3)
    }

    func testFullRun_paysFiveInARow() {
        let m = matrix([0, 0, 0, 0, 0])
        let result = StrikeEvaluator.evaluate(matrix: m, paylines: [payline], bag: bag)[0]
        XCTAssertEqual(result.hits, 5)
        XCTAssertEqual(result.payout, 22)
    }

    func testBrokenRun_paysForRunLengthOnly() {
        // 0,0,0,1,1 -> run of symbol 0 stops at index 3 (mismatch), hits = 3, pays the 3-tier.
        let m = matrix([0, 0, 0, 1, 1])
        let result = StrikeEvaluator.evaluate(matrix: m, paylines: [payline], bag: bag)[0]
        XCTAssertEqual(result.hits, 3)
        XCTAssertEqual(result.payout, 5)
    }

    func testTwoInARow_paysZero_belowMinimumHits() {
        // 0,0,1,1,1 -> symbol 0 run is only 2 hits, and symbol0's 2-tier payout is 0.
        let m = matrix([0, 0, 1, 1, 1])
        let result = StrikeEvaluator.evaluate(matrix: m, paylines: [payline], bag: bag)[0]
        XCTAssertEqual(result.hits, 2)
        XCTAssertEqual(result.payout, 0)
        XCTAssertFalse(result.isValuable)
    }

    func testWildExtendsRun() {
        // 0,0,wild,0,0 -> wild is transparent, full 5-hit run of symbol 0.
        let m = matrix([0, 0, 2, 0, 0])
        let result = StrikeEvaluator.evaluate(matrix: m, paylines: [payline], bag: bag)[0]
        XCTAssertEqual(result.hits, 5)
        XCTAssertEqual(result.payout, 22)
    }

    func testWildLedRun_paysUsingFirstColumnSymbolNotTheAdoptedAnchor() {
        // wild,1,1,1,1 -> the run is matched against symbol 1 (adopted after the leading wild),
        // giving 5 hits, but AS3's StrikeValuatorsData.Evaluate() pays using symbol0 (the FIRST
        // column's symbol, i.e. Wild) regardless of which symbol the run matched — ported
        // faithfully rather than "corrected." So payout must be Wild's 5-tier (20), not
        // symbol 1's 5-tier (16).
        let m = matrix([2, 1, 1, 1, 1])
        let result = StrikeEvaluator.evaluate(matrix: m, paylines: [payline], bag: bag)[0]
        XCTAssertEqual(result.hits, 5)
        XCTAssertEqual(result.payout, 20)
    }

    func testAllWild_paysUsingWildTable() {
        let m = matrix([2, 2, 2, 2, 2])
        let result = StrikeEvaluator.evaluate(matrix: m, paylines: [payline], bag: bag)[0]
        XCTAssertEqual(result.hits, 5)
        XCTAssertEqual(result.payout, 20)
    }

    func testMismatchAtSecondColumn_paysZero() {
        let m = matrix([0, 1, 0, 0, 0])
        let result = StrikeEvaluator.evaluate(matrix: m, paylines: [payline], bag: bag)[0]
        XCTAssertEqual(result.hits, 1)
        XCTAssertEqual(result.payout, 0) // symbol0 has no 1-tier payout configured
    }

    func testEvaluate_producesOneResultPerPaylineRegardlessOfOutcome() {
        let losingPayline = Payline(id: 1, color: 0, cells: [0, 1, 2, 3, 4])
        let m = matrix([0, 1, 0, 1, 0])
        let results = StrikeEvaluator.evaluate(matrix: m, paylines: [payline, losingPayline], bag: bag)
        XCTAssertEqual(results.count, 2)
    }
}
