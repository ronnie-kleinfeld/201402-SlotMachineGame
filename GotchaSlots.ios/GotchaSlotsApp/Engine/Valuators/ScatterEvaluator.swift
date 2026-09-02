import Foundation

struct ScatterResult {
    let symbolID: Int
    let hits: Int
    let payout: Double
    var isValuable: Bool { payout > 0 }
}

/// Ports BaseScatterValuatorData.Evaluate(): a grid-wide count of cells matching one specific
/// symbol, payout via PayoutByHits(count). Reused for every scatter-style special symbol —
/// FreeSpins, Bomb, MiniSpin, Multiplier, and the collectibles (Ace/Gold/King) — since AS3's
/// BombValuatorData/MiniSpinValuatorData/FreeSpinsValuatorData/AceValuatorData/etc. are all
/// thin one-line subclasses that just plug a different symbol into this exact same evaluator.
enum ScatterEvaluator {
    static func evaluate(matrix: ResultMatrix, symbol: SymbolConfig) -> ScatterResult {
        let hits = matrix.cells.values.filter { $0 == symbol.id }.count
        let payout = symbol.payoutTable.payout(forHits: hits)
        return ScatterResult(symbolID: symbol.id, hits: hits, payout: payout)
    }
}
