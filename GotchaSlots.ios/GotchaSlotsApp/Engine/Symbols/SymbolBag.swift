import Foundation

/// Ports SymbolsData.CalculateOdds()/RandomID: a weighted-random symbol picker built as a flat
/// "bag" of symbol IDs, not a classic reel strip.
///
/// Bomb, MiniSpin, and Multiplier are deliberately NOT added to the bag — confirmed by reading
/// SymbolsData.CalculateOdds() in full: it only calls AddOdds for BonusGame, FreeSpins, Wild,
/// and the collectibles (Ace/Gold/King). Bomb/MiniSpin/Multiplier can never be drawn during
/// normal grid generation; they only ever appear as a "consolation prize" planted directly into
/// an already-generated forced-loss grid (see SpinResolver's decorateConsolationLoss, porting
/// ResultMatrixHandler's AddRandomBomb/AddRandomMiniSpins/AddRandomMultiplier). This is a
/// deliberate design choice in the original game, not an oversight — reproduced faithfully.
final class SymbolBag {
    private(set) var bag: [Int] = []
    let normalSymbols: [SymbolConfig]
    let wild: SymbolConfig
    let factor: Double

    let freeSpins: SymbolConfig?
    let bomb: SymbolConfig?
    let miniSpin: SymbolConfig?
    let bonusGame: SymbolConfig?
    let multiplier: SymbolConfig?
    let ace: SymbolConfig?
    let gold: SymbolConfig?
    let king: SymbolConfig?

    private var allSymbolsByID: [Int: SymbolConfig] = [:]

    init(
        normalSymbols: [SymbolConfig],
        wild: SymbolConfig,
        factor: Double,
        freeSpins: SymbolConfig? = nil,
        bomb: SymbolConfig? = nil,
        miniSpin: SymbolConfig? = nil,
        bonusGame: SymbolConfig? = nil,
        multiplier: SymbolConfig? = nil,
        ace: SymbolConfig? = nil,
        gold: SymbolConfig? = nil,
        king: SymbolConfig? = nil
    ) {
        self.normalSymbols = normalSymbols
        self.wild = wild
        self.factor = factor
        self.freeSpins = freeSpins
        self.bomb = bomb
        self.miniSpin = miniSpin
        self.bonusGame = bonusGame
        self.multiplier = multiplier
        self.ace = ace
        self.gold = gold
        self.king = king

        for symbol in normalSymbols { allSymbolsByID[symbol.id] = symbol }
        for symbol in [wild, freeSpins, bomb, miniSpin, bonusGame, multiplier, ace, gold, king].compactMap({ $0 }) {
            allSymbolsByID[symbol.id] = symbol
        }

        calculateOdds()
    }

    /// Ports SymbolsData.CalculateOdds(): for each normal symbol, its slot count is
    /// ceil(1 / max(payoutSum/normalSum, 0.05)) * 10 — a symbol worth a larger share of total
    /// payout gets fewer bag slots (rarer). Special symbols are appended after, each getting
    /// ceil(currentBagSize * specialOdds) additional slots — order matters, since specialOdds
    /// is a fraction of the bag size *at the time it's added*. AS3 order: BonusGame, FreeSpins,
    /// Wild, then collectibles (Ace, Gold, King) — Bomb/MiniSpin/Multiplier excluded (see above).
    private func calculateOdds() {
        bag.removeAll()

        let normalSum = normalSymbols.reduce(0.0) { $0 + $1.payoutTable.payoutSum }
        for symbol in normalSymbols {
            let ratio = max(symbol.payoutTable.payoutSum / normalSum, 0.05)
            let slotCount = Int(ceil(1.0 / ratio)) * 10
            bag.append(contentsOf: repeatElement(symbol.id, count: slotCount))
        }

        if let bonusGame { addOdds(symbolID: bonusGame.id, specialOdds: Self.bonusGameSpecialOdds) }
        if let freeSpins { addOdds(symbolID: freeSpins.id, specialOdds: 0.05 * factor) }
        addOdds(symbolID: wild.id, specialOdds: 0.25 * factor)
        if let ace { addOdds(symbolID: ace.id, specialOdds: 0.02 * factor) }
        if let gold { addOdds(symbolID: gold.id, specialOdds: 0.02 * factor) }
        if let king { addOdds(symbolID: king.id, specialOdds: 0.02 * factor) }
    }

    /// Ports BonusGameSymbolData.SpecialOdds: `Main.Instance.Device.IsMobile ? 0.02 : 0.1 *
    /// factor` — this port targets iOS exclusively, i.e. always the mobile branch, so this is
    /// simply the constant 0.02 (deliberately NOT scaled by factor, unlike every other special
    /// symbol's odds — that asymmetry is in the original source, not a transcription slip).
    private static let bonusGameSpecialOdds = 0.02

    /// Ports SymbolsData.AddOdds(specialSymbol): appends ceil(currentBagSize * specialOdds)
    /// more slots for this symbol's ID.
    private func addOdds(symbolID: Int, specialOdds: Double) {
        let count = Int(ceil(Double(bag.count) * specialOdds))
        bag.append(contentsOf: repeatElement(symbolID, count: count))
    }

    /// Ports SymbolsData.RandomID: uniform draw from the weighted bag.
    var randomID: Int {
        bag[Int.random(in: 0..<bag.count)]
    }

    /// Ports SymbolsData.RandomNormalID: uniform draw among normal symbols only.
    var randomNormalID: Int {
        normalSymbols[Int.random(in: 0..<normalSymbols.count)].id
    }

    func symbol(withID id: Int) -> SymbolConfig? {
        allSymbolsByID[id]
    }

    /// Ports BaseSpecialSymbolData.IsRandomOdds: `Math.floor(Math.random() * (1/SpecialOdds))
    /// == 0`, i.e. true with probability SpecialOdds. Used to gate whether a consolation symbol
    /// actually gets planted into a forced-loss grid (SpinResolver), not a guarantee.
    static func isRandomOdds(specialOdds: Double) -> Bool {
        guard specialOdds > 0 else { return false }
        return Int(Double.random(in: 0..<1) * (1.0 / specialOdds)) == 0
    }

    /// Ports BombSymbolData.SpecialOdds = 0.2 * factor.
    var bombSpecialOdds: Double { 0.2 * factor }
    /// Ports MiniSpinSymbolData.SpecialOdds = 0.2 * factor.
    var miniSpinSpecialOdds: Double { 0.2 * factor }
    /// Ports MultiplierSymbolData.SpecialOdds = 0.1 * factor.
    var multiplierSpecialOdds: Double { 0.1 * factor }
}
