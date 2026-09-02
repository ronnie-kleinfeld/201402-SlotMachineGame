import XCTest
@testable import GotchaSlotsIOS

/// Covers the four grid shapes besides 5x3 (see Paylines5x3Tests for that one). 255 hardcoded
/// line definitions total across all five shapes is the highest transcription-error risk in
/// the project, so each gets a count/bounds check plus a handful of exact spot-checks against
/// the AS3 source.
final class PaylinesOtherGridsTests: XCTestCase {
    // MARK: - 3x3 (27 lines, 3 cells each, grid indices 0...8)

    func test3x3_countAndIDs() {
        XCTAssertEqual(paylines3x3.count, 27)
        XCTAssertEqual(paylines3x3.map { $0.id }, Array(0...26))
    }

    func test3x3_cellsWithinBounds() {
        for line in paylines3x3 {
            XCTAssertEqual(line.cells.count, 3)
            for cell in line.cells { XCTAssertTrue((0...8).contains(cell)) }
        }
    }

    func test3x3_spotChecks() {
        XCTAssertEqual(paylines3x3[0].cells, [3, 4, 5]) // middle row
        XCTAssertEqual(paylines3x3[1].cells, [0, 1, 2]) // top row
        XCTAssertEqual(paylines3x3[2].cells, [6, 7, 8]) // bottom row
        XCTAssertEqual(paylines3x3[3].cells, [0, 4, 8]) // diagonal
        XCTAssertEqual(paylines3x3[26].cells, [6, 7, 5]) // last line
    }

    // MARK: - 5x1 (1 line, 5 cells, grid indices 0...4)

    func test5x1_singleHorizontalLine() {
        XCTAssertEqual(paylines5x1.count, 1)
        XCTAssertEqual(paylines5x1[0].id, 0)
        XCTAssertEqual(paylines5x1[0].cells, [0, 1, 2, 3, 4])
    }

    // MARK: - 5x4 (100 lines, 5 cells each, grid indices 0...19)

    func test5x4_countAndIDs() {
        XCTAssertEqual(paylines5x4.count, 100)
        XCTAssertEqual(paylines5x4.map { $0.id }, Array(0...99))
    }

    func test5x4_cellsWithinBounds() {
        for line in paylines5x4 {
            XCTAssertEqual(line.cells.count, 5)
            for cell in line.cells { XCTAssertTrue((0...19).contains(cell)) }
        }
    }

    func test5x4_spotChecks() {
        XCTAssertEqual(paylines5x4[50].cells, [5, 11, 7, 13, 9])
        XCTAssertEqual(paylines5x4[99].cells, [15, 16, 2, 18, 19])
    }

    // MARK: - 5x5 (100 lines, 5 cells each, grid indices 0...24)

    func test5x5_countAndIDs() {
        XCTAssertEqual(paylines5x5.count, 100)
        XCTAssertEqual(paylines5x5.map { $0.id }, Array(0...99))
    }

    func test5x5_cellsWithinBounds() {
        for line in paylines5x5 {
            XCTAssertEqual(line.cells.count, 5)
            for cell in line.cells { XCTAssertTrue((0...24).contains(cell)) }
        }
    }

    func test5x5_spotChecks() {
        XCTAssertEqual(paylines5x5[50].cells, [10, 11, 7, 3, 9])
        XCTAssertEqual(paylines5x5[99].cells, [15, 1, 2, 3, 24])
    }

    // MARK: - Cross-shape sanity: grid shape cell counts line up with each table's bounds

    func testGridShapeCellCountsMatchPaylineTableBounds() {
        XCTAssertEqual(GridShape.grid3x3.cellCount, 9)
        XCTAssertEqual(GridShape.grid5x1.cellCount, 5)
        XCTAssertEqual(GridShape.grid5x3.cellCount, 15)
        XCTAssertEqual(GridShape.grid5x4.cellCount, 20)
        XCTAssertEqual(GridShape.grid5x5.cellCount, 25)
    }
}
