import Foundation

struct ColumnResult {
    let columnIndex: Int
    let symbolID: Int
    let payout: Double
}

/// Ports ColumnValuatorsData.Evaluate() + ResultMatrix{Shape}Data.IsColumnValuable: a column
/// (vertical "payline") wins only if EVERY cell in that column is exactly the same symbol —
/// no Wild substitution, no partial credit. Payout uses the full column height as the hit count.
///
/// Special case ported faithfully from ResultMatrix5x1Data: a 1-row grid always returns no
/// column wins, even though the generic "all cells in the column are equal" check would be
/// trivially true for a single cell. AS3 hardcodes this as an explicit override rather than
/// letting the general rule apply, so this port does too.
enum ColumnEvaluator {
    static func evaluate(matrix: ResultMatrix, gridShape: GridShape, bag: SymbolBag) -> [ColumnResult] {
        guard gridShape != .grid5x1 else { return [] }

        var results: [ColumnResult] = []
        for column in 0..<gridShape.columns {
            let columnCellIndices = (0..<gridShape.rows).map { row in row * gridShape.columns + column }
            let columnValues = columnCellIndices.compactMap { matrix.cells[$0] }
            guard columnValues.count == gridShape.rows, Set(columnValues).count == 1 else { continue }

            let symbolID = columnValues[0]
            guard let symbol = bag.symbol(withID: symbolID) else { continue }
            let payout = symbol.payoutTable.payout(forHits: gridShape.rows)
            guard payout > 0 else { continue }
            results.append(ColumnResult(columnIndex: column, symbolID: symbolID, payout: payout))
        }
        return results
    }
}
