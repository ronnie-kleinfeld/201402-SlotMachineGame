import XCTest
@testable import GotchaSlots

final class ResultMatrixGeneratorTests: XCTestCase {
    let symbol0 = SymbolConfig(id: 0, assetName: "s0", payoutTable: PayoutTable(payoutByHits: [5: 22, 4: 11, 3: 5, 2: 0]))
    let symbol1 = SymbolConfig(id: 1, assetName: "s1", payoutTable: PayoutTable(payoutByHits: [5: 16, 4: 10, 3: 5, 2: 0]))
    let wild = SymbolConfig(id: 2, assetName: "wild", payoutTable: PayoutTable(payoutByHits: [5: 20, 4: 15, 3: 10, 2: 5]))

    lazy var bag = SymbolBag(normalSymbols: [symbol0, symbol1], wild: wild, factor: 1.0)

    func testGeneratedGrid_fillsEveryCellForShape() {
        for _ in 0..<50 {
            let matrix = ResultMatrixGenerator.generate(bag: bag, gridShape: .grid5x3)
            XCTAssertEqual(matrix.cells.count, GridShape.grid5x3.cellCount)
            for i in 0..<GridShape.grid5x3.cellCount {
                XCTAssertNotNil(matrix.cells[i])
            }
        }
    }

    func testGeneratedGrid_onlyContainsBagSymbolIDs() {
        let validIDs: Set<Int> = [symbol0.id, symbol1.id, wild.id]
        for _ in 0..<50 {
            let matrix = ResultMatrixGenerator.generate(bag: bag, gridShape: .grid5x3)
            for value in matrix.cells.values {
                XCTAssertTrue(validIDs.contains(value))
            }
        }
    }
}
