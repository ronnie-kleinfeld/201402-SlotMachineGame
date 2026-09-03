import Foundation

/// Ports the persisted slice of WalletSessionData: balance and lifetime XP. Other session fields
/// (DiagonalWinLimitChips, bet limits, etc.) aren't modeled yet — SpinResolver still takes
/// diagonalWinLimitChips as a fixed parameter rather than reading it from here.
struct WalletState: PersistedState {
    var balance: Double
    /// Ports WalletSessionData's `_xp` — lifetime chips wagered (real AND free spins both grant
    /// XP equal to the total bet; only real spins deduct balance). Never decremented.
    var xp: Double

    /// Ports WalletSessionData.Level as an XP-derived value rather than separate stored state —
    /// the AS3 original computes it the same way (LevelData.GetLevelNumberByXP), so there's no
    /// separate field to let drift out of sync. Gates which machines are unlocked in the lobby
    /// (MachineConfiguration.openOnLevel).
    var level: Int { LevelThresholds.level(forXP: xp) }

    static var defaultValue: WalletState {
        WalletState(balance: 1000, xp: 0)
    }

    private enum CodingKeys: String, CodingKey {
        case balance, xp
    }

    init(balance: Double, xp: Double) {
        self.balance = balance
        self.xp = xp
    }

    /// A wallet saved before `xp` existed decodes with `xp` defaulting to 0 (level 1) rather
    /// than failing the whole decode and silently resetting the player's balance too.
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        balance = try container.decode(Double.self, forKey: .balance)
        xp = try container.decodeIfPresent(Double.self, forKey: .xp) ?? 0
    }
}
