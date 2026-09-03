import Foundation

/// Ports LevelData's XP/level math (`common/data/session/level/LevelData.as`): the player's
/// level is never stored directly — it's derived fresh from lifetime XP via a compounding
/// golden-ratio-based threshold series ("based on the Levels.xlsx excel file", per the AS3
/// source comment). WalletState.level reads through this.
enum LevelThresholds {
    /// Ports CommonConsts.GOLDEN_PART_BIG (1/φ).
    private static let goldenPartBig = 0.61803398874989484820458683436564
    /// Ports CommonConsts.GOLDEN_RATIO (φ).
    private static let goldenRatio = 1.6180339887498948482045868343656
    /// Safety cap on the search loop — AS3 bounds it at int.MAX_VALUE, which is unreachable in
    /// practice; this is a much smaller but still practically-unreachable bound (level growth is
    /// roughly cubic, so this represents an absurdly large XP total) to guarantee termination.
    private static let maxLevel = 100_000

    /// Ports LevelData.GetLevelNumberByXP(xp): walks the same threshold series LevelData's
    /// constructor builds (InitXP), returning the level whose [minXP, nextMinXP) range contains
    /// `xp`.
    static func level(forXP xp: Double) -> Int {
        guard xp.isFinite, xp > 0 else { return 1 }

        var gSum = 200.0
        var xpSum = 0.0
        var minXP = 0.0
        var nextMinXP = 0.0
        for level in 1...maxLevel {
            gSum += Double(level) * goldenPartBig
            xpSum += gSum
            minXP = nextMinXP
            nextMinXP += xpSum
            if xp >= minXP && xp < nextMinXP {
                return level
            }
        }
        return maxLevel
    }

    /// Ports LevelData.LevelReachedBonusChips: floor(200 + level * GOLDEN_RATIO).
    static func levelReachedBonusChips(forLevel level: Int) -> Double {
        (200 + Double(level) * goldenRatio).rounded(.down)
    }

    /// Ports LevelData.WelcomeBonusChips: floor(200 + level * GOLDEN_RATIO) * 2.
    static func welcomeBonusChips(forLevel level: Int) -> Double {
        levelReachedBonusChips(forLevel: level) * 2
    }

    /// Ports LevelData.TimerBonusChips: floor(LevelReachedBonusChips * GOLDEN_PART_BIG).
    static func timerBonusChips(forLevel level: Int) -> Double {
        (levelReachedBonusChips(forLevel: level) * goldenPartBig).rounded(.down)
    }
}
