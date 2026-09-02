import Foundation

/// Ports BaseAdsHandler's interface (banner + interstitial lifecycle). The original's iOS
/// implementation, `IAdHandler`, wrapped Apple's iAd — discontinued in 2016, so there's no
/// like-for-like target to port to. A real implementation here would most plausibly use Google
/// AdMob's iOS SDK (matching the precedent already set by the Android-side `AdMobHandler` in
/// the AS3 source), but that needs a registered AdMob app/ad-unit ID this session doesn't have
/// and can't create — whether to run ads at all in this port is also a product decision, not
/// resolved here.
protocol AdsProviding {
    func showBanner()
    func removeBanner()

    func loadInterstitial()
    func showInterstitial()
    func removeInterstitial()
}

/// No-op placeholder — every call is inert. Swap for a real ad-network-backed implementation
/// (or delete the call sites entirely, if the product decision is to drop ads) once that's
/// decided; nothing else in the app should need to change, since callers only depend on the
/// `AdsProviding` protocol.
final class NullAdsProvider: AdsProviding {
    func showBanner() {}
    func removeBanner() {}
    func loadInterstitial() {}
    func showInterstitial() {}
    func removeInterstitial() {}
}
