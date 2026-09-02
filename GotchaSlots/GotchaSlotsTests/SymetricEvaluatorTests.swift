import XCTest
@testable import GotchaSlots

final class SymetricEvaluatorTests: XCTestCase {
    let symbol0 = SymbolConfig(id: 0, assetName: "s0", payoutTable: PayoutTable(payoutByHits: [5: 22, 4: 11, 3: 5, 2: 0]))
    let symbol1 = SymbolConfig(id: 1, assetName: "s1", payoutTable: PayoutTable(payoutByHits: [5: 16, 4: 10, 3: 5, 2: 0]))
    let wild = SymbolConfig(id: 2, assetName: "wild", payoutTable: PayoutTable(payoutByHits: [5: 20, 4: 15, 3: 10, 2: 5]))
    lazy var bag = SymbolBag(normalSymbols: [symbol0, symbol1], wild: wild, factor: 1.0)

    let row0 = Payline(id: 0, color: 0, cells: [0, 1, 2, 3, 4])

    func matrix(_ row: [Int]) -> ResultMatrix {
        var cells: [Int: Int] = [:]
        for (i, id) in row.enumerated() { cells[i] = id }
        return ResultMatrix(cells: cells, gridShape: .grid5x3)
    }

    func testMirroredCells_isValuable_paysOnCenterSymbol() {
        // 0,1,X,1,0 -> cells[0]==cells[4] (0==0) && cells[1]==cells[3] (1==1). Center is index 2.
        // Center symbol is symbol1 (id 1) even though outer cells are symbol0 — pays via
        // whatever sits at the center, not the mirrored outer symbol.
        let m = matrix([0, 1, 1, 1, 0])
        let results = SymetricEvaluator.evaluate(matrix: m, horizontalPaylines: [row0], bag: bag)
        XCTAssertEqual(results.count, 1)
        // Center symbol1, 5 hits (ColumnsCount) -> payout for symbol1 at hits=5 is 16.
        XCTAssertEqual(results[0].payout, 16)
    }

    func testNoMirror_isNotValuable_producesNoResult() {
        // 0,1,1,0,1 -> cells[0]!=cells[4] (0 vs 1) -> not symmetric.
        let m = matrix([0, 1, 1, 0, 1])
        let results = SymetricEvaluator.evaluate(matrix: m, horizontalPaylines: [row0], bag: bag)
        XCTAssertTrue(results.isEmpty)
    }

    func testExactEquality_noWildSubstitution() {
        // wild,1,1,1,0 -> cells[0]=wild(2), cells[4]=0 -> 2 != 0, NOT symmetric even though a
        // Strike-style evaluator would treat Wild as a match. Symetric uses exact equality only.
        let m = matrix([2, 1, 1, 1, 0])
        let results = SymetricEvaluator.evaluate(matrix: m, horizontalPaylines: [row0], bag: bag)
        XCTAssertTrue(results.isEmpty)
    }

    func testZeroPayoutCenter_producesNoResult() {
        // Mirrored (cells[0]==cells[4], cells[1]==cells[3]) but the center symbol's payout at
        // hits=ColumnsCount(5) is explicitly 0 -> no result, even though the mirror matched.
        let zeroAtFive = SymbolConfig(id: 3, assetName: "z", payoutTable: PayoutTable(payoutByHits: [5: 0, 4: 10]))
        let bagWithZero = SymbolBag(normalSymbols: [symbol0, symbol1, zeroAtFive], wild: wild, factor: 1.0)
        let cells: [Int: Int] = [0: 1, 1: 1, 2: 3, 3: 1, 4: 1]
        let m = ResultMatrix(cells: cells, gridShape: .grid5x3)
        let results = SymetricEvaluator.evaluate(matrix: m, horizontalPaylines: [row0], bag: bagWithZero)
        XCTAssertTrue(results.isEmpty)
    }
}
