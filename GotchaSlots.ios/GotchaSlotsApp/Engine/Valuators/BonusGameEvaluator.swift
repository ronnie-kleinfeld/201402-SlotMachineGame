import Foundation

/// One payline's bonus-symbol count, ported from BonusGameValuatorData — produced for every
/// payline (even non-triggering ones), same convention as StrikeResult, since
/// BonusGameValuatorsData.CalculatePaylinesPayout indexes by payline position.
struct BonusGameResult {
    let payline: Payline
    let hits: Int
    let payout: Double
}

/// Ports BonusGameValuatorsData.Evaluate(): unlike FreeSpins/Bomb/etc (grid-wide scatter
/// counts), the bonus-game trigger is PAYLINE-SCOPED — for each payline, count how many of its
/// cells contain the bonus symbol, and look up the payout/trigger via that count.
enum BonusGameEvaluator {
    static func evaluate(matrix: ResultMatrix, paylines: [Payline], bonusGameSymbol: SymbolConfig) -> [BonusGameResult] {
        paylines.map { payline in
            let hits = payline.cells.filter { matrix.cells[$0] == bonusGameSymbol.id }.count
            let payout = bonusGameSymbol.payoutTable.payout(forHits: hits)
            return BonusGameResult(payline: payline, hits: hits, payout: payout)
        }
    }
}
