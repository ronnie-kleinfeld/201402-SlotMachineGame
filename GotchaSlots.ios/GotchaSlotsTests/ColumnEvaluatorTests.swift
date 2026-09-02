import XCTest
@testable import GotchaSlotsIOS

final class ColumnEvaluatorTests: XCTestCase {
    let symbol0 = SymbolConfig(id: 0, assetName: "s0", payoutTable: PayoutTable(payoutByHits: [5: 22, 4: 11, 3: 5, 2: 0]))
    let symbol1 = SymbolConfig(id: 1, assetName: "s1", payoutTable: PayoutTable(payoutByHits: [5: 16, 4: 10, 3: 5, 2: 0]))
    let wild = SymbolConfig(id: 2, assetName: "wild", payoutTable: PayoutTable(payoutByHits: [5: 20, 4: 15, 3: 10, 2: 5]))
    lazy var bag = SymbolBag(normalSymbols: [symbol0, symbol1], wild: wild, factor: 1.0)

    /// Row-major 5x3 grid (rows given top to bottom, 5 values each) — every row distinct enough
    /// that only the column(s) under test end up uniform, so results.count is unambiguous.
    func matrix(rows: [[Int]]) -> ResultMatrix {
        precondition(rows.count == 3 && rows.allSatisfy { $0.count == 5 })
        var cells: [Int: Int] = [:]
        for (r, row) in rows.enumerated() {
            for (c, id) in row.enumerated() { cells[r * 5 + c] = id }
        }
        return ResultMatrix(cells: cells, gridShape: .grid5x3)
    }

    func testAllCellsInColumnEqual_isValuable() {
        // Column 0 = symbol0 in every row; every other column varies row to row so it can't
        // accidentally also be uniform.
        let m = matrix(rows: [
            [0, 1, 0, 1, 0],
            [0, 0, 1, 0, 1],
            [0, 1, 1, 1, 0],
        ])
        let results = ColumnEvaluator.evaluate(matrix: m, gridShape: .grid5x3, bag: bag)
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results[0].columnIndex, 0)
        XCTAssertEqual(results[0].payout, 5) // symbol0 at 3 hits = 5
    }

    func testMismatchedColumn_isNotValuable() {
        let m = matrix(rows: [
            [0, 1, 0, 1, 0],
            [1, 0, 1, 0, 1], // column 0 breaks here (1 != 0)
            [0, 1, 1, 1, 0],
        ])
        let results = ColumnEvaluator.evaluate(matrix: m, gridShape: .grid5x3, bag: bag)
        XCTAssertTrue(results.isEmpty)
    }

    func testNoWildSubstitution() {
        // wild, symbol0, symbol0 in a column should NOT count as a column win — exact equality
        // only (ports ResultMatrix5x3Data.IsColumnValuable's direct == check).
        let m = matrix(rows: [
            [2, 1, 0, 1, 0], // wild at column 0
            [0, 0, 1, 0, 1],
            [0, 1, 1, 1, 0],
        ])
        let results = ColumnEvaluator.evaluate(matrix: m, gridShape: .grid5x3, bag: bag)
        XCTAssertTrue(results.isEmpty)
    }

    func testGrid5x1_neverProducesColumnWins() {
        // Ports ResultMatrix5x1Data.IsColumnValuable's hardcoded always-empty override — a
        // single-row grid's "column" is trivially one cell, which the generic all-equal rule
        // would treat as a win, but AS3 explicitly special-cases this to never win.
        let cells: [Int: Int] = [0: 0, 1: 0, 2: 0, 3: 0, 4: 0]
        let m = ResultMatrix(cells: cells, gridShape: .grid5x1)
        let results = ColumnEvaluator.evaluate(matrix: m, gridShape: .grid5x1, bag: bag)
        XCTAssertTrue(results.isEmpty)
    }

    func testNotGatedBySelectedPaylines_allColumnsCanPaySimultaneously() {
        // Every column matches -> all 5 columns should produce results (ColumnValuatorsData.
        // CalculatePaylinesPayout is NOT bounded by selectedPaylines, unlike Strike/Symetric).
        let m = matrix(rows: [
            [0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0],
        ])
        let results = ColumnEvaluator.evaluate(matrix: m, gridShape: .grid5x3, bag: bag)
        XCTAssertEqual(results.count, 5)
    }
}
