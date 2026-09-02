import Foundation

/// Ports BaseSymbolData's payout table: PayoutByHits(hits) with no interpolation between tiers.
/// Keys are hit counts (1...5); a missing key means 0 payout at that hit count.
struct PayoutTable: Codable {
    var payoutByHits: [Int: Double]

    /// Ports BaseSymbolData.MinimumHitsToPayout: the lowest hit count (1...5) with a configured
    /// nonzero payout, scanning upward. Returns .max if no tier pays (matches AS3's int.MAX_VALUE).
    var minimumHitsToPayout: Int {
        for hits in 1...5 where (payoutByHits[hits] ?? 0) > 0 {
            return hits
        }
        return .max
    }

    /// Ports BaseSymbolData.PayoutByHits(hits): 0 below the minimum-hits threshold, else the
    /// exact configured payout for that hit count.
    func payout(forHits hits: Int) -> Double {
        guard hits >= minimumHitsToPayout else { return 0 }
        return payoutByHits[hits] ?? 0
    }

    /// Ports BaseSymbolData.PayoutSum, floored at 1 — drives SymbolBag's inverse-payout weighting.
    var payoutSum: Double {
        max(payoutByHits.values.reduce(0, +), 1)
    }
}

/// Ports NormalSymbolData: id, art reference, and per-hit-count payout coefficients.
struct SymbolConfig: Codable, Identifiable {
    let id: Int
    let assetName: String
    let payoutTable: PayoutTable
}

/// Ports the 9 valuator-composition booleans threaded through every machine constructor call
/// in Main.as's InitMachines(). Phase 1 only consumes `strike`; the rest are carried through
/// the config now so Phase 3 doesn't need to touch MachineConfiguration again.
struct MachineFeatureFlags: Codable {
    var strikeValuator: Bool
    var freeSpinsScatterValuator: Bool
    var bombScatterValuator: Bool
    var miniSpinScatterValuator: Bool
    var collectiblesScatterValuator: Bool
    var bonusGameValuator: Bool
    var columnValuator: Bool
    var symetricValuator: Bool
    var multiplierScatterValuator: Bool
}

/// Ports the constructor-argument pattern of SlotsBaseLobbyMachineData / LobbyMachine{Shape}Data —
/// one generic engine configured per machine, rather than a Swift subclass per machine.
///
/// The special symbols are optional because AS3 only ever adds them to a machine's SymbolsData
/// when the matching MachineFeatureFlags boolean is true (InitValuatorsClass); a machine with
/// e.g. `bombScatterValuator: false` never constructs a BombSymbolData at all. A present
/// MachineConfiguration.bomb with features.bombScatterValuator == false would be a
/// configuration error — the two must agree.
struct MachineConfiguration: Codable, Identifiable {
    let id: Int
    let machineName: String
    let gridShape: GridShape
    let normalSymbols: [SymbolConfig]
    let wild: SymbolConfig
    /// AS3 `factor`: volatility/denomination scalar applied to special-symbol payouts and odds.
    let factor: Double
    let maxPaylines: Int
    let openOnLevel: Int
    let isComingSoon: Bool
    let depreciationRatio: Double
    let features: MachineFeatureFlags

    // Special symbols — present only when the matching feature flag is true. Defaulted to nil
    // so existing call sites (tests, fixtures) that predate Phase 3 don't need updating.
    var freeSpins: SymbolConfig? = nil
    var bomb: SymbolConfig? = nil
    var miniSpin: SymbolConfig? = nil
    var bonusGame: SymbolConfig? = nil
    var multiplier: SymbolConfig? = nil
    var ace: SymbolConfig? = nil
    var gold: SymbolConfig? = nil
    var king: SymbolConfig? = nil
}
