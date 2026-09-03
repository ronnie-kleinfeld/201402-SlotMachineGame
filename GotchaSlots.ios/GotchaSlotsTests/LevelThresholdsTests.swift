import XCTest
@testable import GotchaSlotsIOS

final class LevelThresholdsTests: XCTestCase {
    // Thresholds independently computed from the same AS3 formula (LevelData.GetLevelNumberByXP)
    // via a standalone script, not just re-derived from this port's own code.
    func testLevel_matchesIndependentlyComputedThresholds() {
        // Exact minXP per level, from a standalone re-implementation of the same AS3 formula —
        // test values sit safely on either side (not hair-splitting the exact boundary, which
        // is sensitive to floating-point rounding in how the value is written here).
        XCTAssertEqual(LevelThresholds.level(forXP: 0), 1)
        XCTAssertEqual(LevelThresholds.level(forXP: 199), 1)
        XCTAssertEqual(LevelThresholds.level(forXP: 201), 2) // level 2 minXP = 200.618...
        XCTAssertEqual(LevelThresholds.level(forXP: 602), 2) // just below level 3 minXP = 603.09...
        XCTAssertEqual(LevelThresholds.level(forXP: 604), 3)
        XCTAssertEqual(LevelThresholds.level(forXP: 2022), 5) // level 5 minXP = 2021.63...
        XCTAssertEqual(LevelThresholds.level(forXP: 9306), 10) // level 10 minXP = 9305.93...
        XCTAssertEqual(LevelThresholds.level(forXP: 42521), 20) // level 20 minXP = 42520.92...
        XCTAssertEqual(LevelThresholds.level(forXP: 412318), 50) // level 50 minXP = 412317.25...
        XCTAssertEqual(LevelThresholds.level(forXP: 15444890), 150) // level 150 minXP = 15444889.38...
    }

    func testLevel_isMonotonicallyNonDecreasingWithXP() {
        var previousLevel = LevelThresholds.level(forXP: 0)
        var xp = 0.0
        while xp < 20000 {
            xp += 37 // an arbitrary non-round step
            let level = LevelThresholds.level(forXP: xp)
            XCTAssertGreaterThanOrEqual(level, previousLevel)
            previousLevel = level
        }
    }

    func testLevel_negativeOrNonFiniteXP_isLevel1() {
        XCTAssertEqual(LevelThresholds.level(forXP: -100), 1)
        XCTAssertEqual(LevelThresholds.level(forXP: .nan), 1)
        XCTAssertEqual(LevelThresholds.level(forXP: .infinity), 1)
    }

    func testLevelReachedBonusChips_matchesFormula() {
        // Ports floor(200 + level * GOLDEN_RATIO).
        XCTAssertEqual(LevelThresholds.levelReachedBonusChips(forLevel: 1), 201)
        XCTAssertEqual(LevelThresholds.levelReachedBonusChips(forLevel: 10), 216)
        XCTAssertEqual(LevelThresholds.levelReachedBonusChips(forLevel: 100), 361)
    }
}
