import Foundation

/// Ports SocialHandler's interface (login state + share-to-Facebook hooks fired from
/// SlotsMachineController on big wins/bonus triggers) as a protocol, NOT a working
/// implementation — the original wraps the "GoViral" ANE around the native Facebook SDK, and
/// wiring the real thing here needs a registered Facebook App ID (Meta developer account,
/// Info.plist URL scheme registration, `FacebookSDK`/`FBSDKCoreKit` via SPM) that this session
/// has no credentials for and can't create.
///
/// `SocialHandler` was for share-to-Facebook, not sign-in/auth (confirmed by reading the AS3
/// source: `Login()`/`Logout()` exist but every other method is a `ShareX()` call fired from
/// win-presentation code) — a real iOS port replacing it should probably use native Facebook
/// SDK for share parity, plus Sign in with Apple (required by App Store guidelines when any
/// third-party login exists) if an account system is ever added. Neither is implemented here.
protocol SocialSharing {
    var isLoggedIn: Bool { get }
    func login() async -> Bool
    func logout()

    func shareBigWin(chips: Double)
    func shareMegaWin(chips: Double)
    func shareBonusGame(chips: Double)
    func shareFiveInARow()
    func shareFourInARow()
}

/// No-op placeholder — every call is inert. Swap for a real Facebook-SDK-backed implementation
/// once real credentials exist; nothing else in the app should need to change, since callers
/// only depend on the `SocialSharing` protocol.
final class NullSocialSharing: SocialSharing {
    var isLoggedIn: Bool { false }
    func login() async -> Bool { false }
    func logout() {}

    func shareBigWin(chips: Double) {}
    func shareMegaWin(chips: Double) {}
    func shareBonusGame(chips: Double) {}
    func shareFiveInARow() {}
    func shareFourInARow() {}
}
