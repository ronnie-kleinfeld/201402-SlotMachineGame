import Foundation

/// One horizontal payline's symmetric-match result, ported from SymetricValuatorData. Unlike
/// StrikeResult, only produced for paylines that actually matched — SymetricValuatorsData.
/// Evaluate() filters to IsValuable entries before storing them (confirmed by reading the AS3
/// source), so this array never contains "losing" entries the way StrikeResult's does.
struct SymetricResult {
    let payline: Payline
    let payout: Double
}

/// Ports SymetricValuatorsData.Evaluate(): a non-classic mirror-match check over horizontal
/// paylines only (cells[0]==cells[N-1] && cells[1]==cells[N-2] && ...), paying based on the
/// CENTER symbol regardless of what the outer/mirrored symbols actually are. Exact equality —
/// no Wild substitution, unlike StrikeEvaluator.
enum SymetricEvaluator {
    /// `horizontalPaylines` is the first `gridShape.rows` entries of the full payline table —
    /// by convention (confirmed across every Paylines{Shape}Data.as file) paylines with IDs
    /// 0..<rows are exactly the horizontal rows, and AS3's InitHorizontalPaylines() duplicates
    /// those same entries verbatim rather than deriving them differently.
    static func evaluate(matrix: ResultMatrix, horizontalPaylines: [Payline], bag: SymbolBag) -> [SymetricResult] {
        horizontalPaylines.compactMap { payline in
            guard isSymetricValuable(payline: payline, matrix: matrix) else { return nil }
            let centerIndex = payline.cells.count / 2
            guard let centerCellID = matrix.cells[payline.cells[centerIndex]],
                  let centerSymbol = bag.symbol(withID: centerCellID) else { return nil }

            let payout = centerSymbol.payoutTable.payout(forHits: payline.cells.count)
            guard payout > 0 else { return nil }
            return SymetricResult(payline: payline, payout: payout)
        }
    }

    /// Ports Payline3Data/Payline5Data.IsSymetricValuable: mirrored cell pairs must be exactly
    /// equal (cells[i] == cells[count-1-i] for every i before the center).
    private static func isSymetricValuable(payline: Payline, matrix: ResultMatrix) -> Bool {
        let cells = payline.cells
        let half = cells.count / 2
        for i in 0..<half {
            guard matrix.cells[cells[i]] == matrix.cells[cells[cells.count - 1 - i]] else { return false }
        }
        return true
    }
}
