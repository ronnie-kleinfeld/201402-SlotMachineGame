import Foundation

/// Ports the bonus-collection slice of RareSessionData — kept separate from WalletState the same
/// way the AS3 original splits WalletSessionData (balance/XP) from RareSessionData (one-time and
/// cooldown-gated bonuses), rather than folding unrelated concerns into one persisted blob.
struct BonusState: PersistedState {
    var isWelcomeBonusCollected: Bool
    /// Ports RareSessionData's `_dailyBonusRecentCollectedIndex`: -1 means never collected;
    /// otherwise cycles 0...3 (day-index 1...4 once passed to the bonus-amount formula).
    var dailyBonusStreakIndex: Int
    var dailyBonusLastCollectedAt: Date?
    var timerBonusLastCollectedAt: Date?

    static var defaultValue: BonusState {
        BonusState(
            isWelcomeBonusCollected: false,
            dailyBonusStreakIndex: -1,
            dailyBonusLastCollectedAt: nil,
            timerBonusLastCollectedAt: nil
        )
    }
}

/// Ports RareSessionData's eligibility checks (IsWelcomeCollected / DailyBonusMSLeftToCellect /
/// IsTimerBonusReady) and the WalletSessionData.Collect* amount formulas, as pure functions over
/// BonusState + the player's level — kept out of the presentation layer so the gating logic has
/// exactly one place to be correct.
enum BonusEligibility {
    /// Ports RareSessionData's daily-bonus reset window: `MS_IN_ONE_DAY * 2` — more than two days
    /// since the last collection and the login streak lapses back to day 1 instead of continuing.
    private static let dailyBonusResetInterval: TimeInterval = 2 * 24 * 60 * 60
    /// Ports MS_IN_ONE_DAY: a daily bonus can be collected again once a full day has passed.
    private static let dailyBonusCooldown: TimeInterval = 24 * 60 * 60
    /// Ports RareSessionData.GAP_BETWEEN_TIMER_BONUS (2 hours).
    static let timerBonusCooldown: TimeInterval = 2 * 60 * 60

    static func isDailyBonusReady(_ state: BonusState, now: Date = Date()) -> Bool {
        guard let last = state.dailyBonusLastCollectedAt else { return true }
        return now.timeIntervalSince(last) >= dailyBonusCooldown
    }

    static func isTimerBonusReady(_ state: BonusState, now: Date = Date()) -> Bool {
        guard let last = state.timerBonusLastCollectedAt else { return true }
        return now.timeIntervalSince(last) >= timerBonusCooldown
    }

    static func timerBonusTimeRemaining(_ state: BonusState, now: Date = Date()) -> TimeInterval {
        guard let last = state.timerBonusLastCollectedAt else { return 0 }
        return max(0, timerBonusCooldown - now.timeIntervalSince(last))
    }

    /// The day-index (1...4) the NEXT daily-bonus collection would use, accounting for a lapsed
    /// streak resetting back to day 1.
    static func nextDailyBonusDayIndex(_ state: BonusState, now: Date = Date()) -> Int {
        if let last = state.dailyBonusLastCollectedAt, now.timeIntervalSince(last) > dailyBonusResetInterval {
            return 1
        }
        return min(state.dailyBonusStreakIndex + 1, 3) + 1
    }

    /// Applies a daily-bonus collection to `state` and returns the chips awarded — ports
    /// WalletSessionData.CollectDailyBonus(dayIndex): `LevelReachedBonusChips * dayIndex`.
    @discardableResult
    static func collectDailyBonus(_ state: inout BonusState, level: Int, now: Date = Date()) -> Double {
        let dayIndex = nextDailyBonusDayIndex(state, now: now)
        state.dailyBonusStreakIndex = dayIndex - 1
        state.dailyBonusLastCollectedAt = now
        return LevelThresholds.levelReachedBonusChips(forLevel: level) * Double(dayIndex)
    }

    /// Ports WalletSessionData.CollectTimerBonus(): `LevelReachedBonusChips * GOLDEN_PART_BIG`.
    @discardableResult
    static func collectTimerBonus(_ state: inout BonusState, level: Int, now: Date = Date()) -> Double {
        state.timerBonusLastCollectedAt = now
        return LevelThresholds.timerBonusChips(forLevel: level)
    }

    /// Ports WalletSessionData.CollectWelcomeBonus(): `WelcomeBonusChips`, then latches
    /// `IsWelcomeCollected` so it never fires again.
    @discardableResult
    static func collectWelcomeBonus(_ state: inout BonusState, level: Int) -> Double {
        state.isWelcomeBonusCollected = true
        return LevelThresholds.welcomeBonusChips(forLevel: level)
    }
}
