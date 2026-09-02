import XCTest
@testable import GotchaSlotsIOS

final class Paylines5x3Tests: XCTestCase {
    func testCount_matchesAS3Source() {
        XCTAssertEqual(paylines5x3.count, 100)
    }

    func testIDsAreSequential0Through99() {
        XCTAssertEqual(paylines5x3.map { $0.id }, Array(0...99))
    }

    func testEveryLineHasFiveCells_withinGridBounds() {
        for line in paylines5x3 {
            XCTAssertEqual(line.cells.count, 5)
            for cell in line.cells {
                XCTAssertTrue((0...14).contains(cell))
            }
        }
    }

    // Spot-check exact transcription against Paylines5x3Data.as (id, cells) for a handful of
    // lines spanning the file, since 100 hardcoded tuples is the highest transcription-error
    // risk in the project.
    func testSpotCheck_line0_middleRow() {
        XCTAssertEqual(paylines5x3[0].cells, [5, 6, 7, 8, 9])
    }

    func testSpotCheck_line1_topRow() {
        XCTAssertEqual(paylines5x3[1].cells, [0, 1, 2, 3, 4])
    }

    func testSpotCheck_line2_bottomRow() {
        XCTAssertEqual(paylines5x3[2].cells, [10, 11, 12, 13, 14])
    }

    func testSpotCheck_line3_vZigzag() {
        XCTAssertEqual(paylines5x3[3].cells, [0, 6, 12, 8, 4])
    }

    func testSpotCheck_line50() {
        XCTAssertEqual(paylines5x3[50].cells, [0, 6, 2, 13, 9])
    }

    func testSpotCheck_line99_lastLine() {
        XCTAssertEqual(paylines5x3[99].cells, [10, 1, 12, 13, 9])
    }
}
