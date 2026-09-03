import XCTest
@testable import GotchaSlotsIOS

final class BonusEligibilityTests: XCTestCase {
    // MARK: - Welcome bonus

    func testCollectWelcomeBonus_latchesTheFlagAndReturnsTheFormulaAmount() {
        var state = BonusState.defaultValue
        XCTAssertFalse(state.isWelcomeBonusCollected)

        let amount = BonusEligibility.collectWelcomeBonus(&state, level: 3)

        XCTAssertTrue(state.isWelcomeBonusCollected)
        XCTAssertEqual(amount, LevelThresholds.welcomeBonusChips(forLevel: 3))
    }

    // MARK: - Daily bonus

    func testDailyBonus_readyOnFirstEverCollection() {
        let state = BonusState.defaultValue
        XCTAssertTrue(BonusEligibility.isDailyBonusReady(state))
        XCTAssertEqual(BonusEligibility.nextDailyBonusDayIndex(state), 1)
    }

    func testDailyBonus_notReadyWithinTheSameDay() {
        var state = BonusState.defaultValue
        let now = Date()
        BonusEligibility.collectDailyBonus(&state, level: 1, now: now)

        XCTAssertFalse(BonusEligibility.isDailyBonusReady(state, now: now.addingTimeInterval(60 * 60 * 12)))
    }

    func testDailyBonus_readyAfterOneFullDay_advancesTheStreak() {
        var state = BonusState.defaultValue
        let day0 = Date()
        BonusEligibility.collectDailyBonus(&state, level: 1, now: day0) // day index 1

        let day1 = day0.addingTimeInterval(24 * 60 * 60 + 1)
        XCTAssertTrue(BonusEligibility.isDailyBonusReady(state, now: day1))
        XCTAssertEqual(BonusEligibility.nextDailyBonusDayIndex(state, now: day1), 2)

        let amount = BonusEligibility.collectDailyBonus(&state, level: 1, now: day1)
        XCTAssertEqual(amount, LevelThresholds.levelReachedBonusChips(forLevel: 1) * 2)
    }

    func testDailyBonus_streakCapsAtDayIndexFour() {
        var state = BonusState.defaultValue
        var now = Date()
        for _ in 0..<10 {
            BonusEligibility.collectDailyBonus(&state, level: 1, now: now)
            now = now.addingTimeInterval(24 * 60 * 60 + 1)
        }
        // Streak plateaus at day index 4 rather than growing forever.
        XCTAssertEqual(BonusEligibility.nextDailyBonusDayIndex(state, now: now), 4)
    }

    func testDailyBonus_lapsingMoreThanTwoDays_resetsTheStreakToDayOne() {
        var state = BonusState.defaultValue
        let start = Date()
        BonusEligibility.collectDailyBonus(&state, level: 1, now: start) // day index 1
        BonusEligibility.collectDailyBonus(&state, level: 1, now: start.addingTimeInterval(24 * 60 * 60 + 1)) // day index 2

        // Player vanishes for 3 days — the streak should lapse back to day 1, not continue at 3.
        let muchLater = start.addingTimeInterval(24 * 60 * 60 * 5)
        XCTAssertEqual(BonusEligibility.nextDailyBonusDayIndex(state, now: muchLater), 1)
    }

    // MARK: - Timer bonus

    func testTimerBonus_readyOnFirstEverCollection() {
        XCTAssertTrue(BonusEligibility.isTimerBonusReady(BonusState.defaultValue))
    }

    func testTimerBonus_notReadyBeforeTwoHoursElapse_readyAfter() {
        var state = BonusState.defaultValue
        let now = Date()
        BonusEligibility.collectTimerBonus(&state, level: 1, now: now)

        XCTAssertFalse(BonusEligibility.isTimerBonusReady(state, now: now.addingTimeInterval(60 * 60)))
        XCTAssertTrue(BonusEligibility.isTimerBonusReady(state, now: now.addingTimeInterval(60 * 60 * 2 + 1)))
    }

    func testTimerBonus_awardsTheFormulaAmount() {
        var state = BonusState.defaultValue
        let amount = BonusEligibility.collectTimerBonus(&state, level: 5)
        XCTAssertEqual(amount, LevelThresholds.timerBonusChips(forLevel: 5))
    }
}
