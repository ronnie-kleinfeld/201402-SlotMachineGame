import Foundation

/// Ports the persisted slice of WalletSessionData: balance and player level. Level gates which
/// machines are unlocked in the lobby (MachineConfiguration.openOnLevel); other session fields
/// (DiagonalWinLimitChips, bet limits, etc.) aren't modeled yet — SpinResolver still takes
/// diagonalWinLimitChips as a fixed parameter rather than reading it from here.
struct WalletState: PersistedState {
    var balance: Double
    var level: Int

    static var defaultValue: WalletState {
        WalletState(balance: 1000, level: 1)
    }
}
