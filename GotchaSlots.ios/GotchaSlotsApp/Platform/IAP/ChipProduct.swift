import Foundation

/// Ports the "Buy Chips" price ladder — specifically `PricesData.AddDefaultPriceOptions`, the
/// fallback table used when no seasonal promotion is active. The AS3 source defines a full
/// promotional-calendar engine (`PricesData`, 24 different scheduler-gated price tables for
/// holidays/weekdays, e.g. Black Friday, "15 minutes to Midnight", every Monday) swapping in
/// different chip amounts for the same price tiers depending on the date — that marketing
/// system is deliberately NOT ported; only the always-available default tier is, since
/// replicating two dozen promotional schedulers is well outside "platform integration" scope.
///
/// Product IDs are new (reverse-DNS, tied to this app's bundle ID) since AS3's `ProductID`
/// constants are opaque GUIDs from a third-party payment aggregator, not valid App Store
/// product identifiers — Apple requires IDs like these regardless of what the original used.
struct ChipProduct: Identifiable {
    let id: String
    let chips: Int

    static let all: [ChipProduct] = [
        ChipProduct(id: "com.gotchaslots.ios.chips.099", chips: 15_000),
        ChipProduct(id: "com.gotchaslots.ios.chips.199", chips: 46_000),
        ChipProduct(id: "com.gotchaslots.ios.chips.499", chips: 100_000),
        ChipProduct(id: "com.gotchaslots.ios.chips.999", chips: 190_000),
    ]

    static func chips(forProductID productID: String) -> Int? {
        all.first { $0.id == productID }?.chips
    }
}
