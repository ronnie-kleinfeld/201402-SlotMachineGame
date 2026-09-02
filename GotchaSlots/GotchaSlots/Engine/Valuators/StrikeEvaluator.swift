import Foundation

/// One payline's evaluated run, ported from StrikeValuatorData. Produced for every payline
/// (even non-winning ones), because CalculatePaylinesPayout indexes into this array by the
/// payline's position, not by which ones won — see WinEvaluatorChain.
struct StrikeResult {
    let payline: Payline
    let hits: Int
    /// Ports `symbol0.PayoutByHits(payboxes.length)`: the coefficient, looked up on the FIRST
    /// column's symbol specifically — not on whichever symbol the run ended up matching. If a
    /// run starts on Wild and is then adopted by a normal symbol two columns in, the payout
    /// still uses Wild's own paytable. This looks like a quirk of the original game, not a
    /// deliberate design choice, but it's reproduced faithfully rather than "corrected."
    let payout: Double
    var isValuable: Bool { payout > 0 }
}

/// Ports StrikeValuatorsData.Evaluate(): the classic consecutive-match payline evaluator.
enum StrikeEvaluator {
    /// Evaluates every payline in `paylines`, in order, producing one result per line.
    static func evaluate(matrix: ResultMatrix, paylines: [Payline], bag: SymbolBag) -> [StrikeResult] {
        paylines.map { evaluate(payline: $0, matrix: matrix, bag: bag) }
    }

    private static func evaluate(payline: Payline, matrix: ResultMatrix, bag: SymbolBag) -> StrikeResult {
        let firstCellID = matrix.cells[payline.cells[0]] ?? bag.wild.id
        // TODO(Phase 3): once scatter/special symbols join the bag, a first cell of a type
        // other than Normal/Wild must short-circuit to a 0-hit result here (AS3 pops the
        // pushed cell back off in that branch). Not reachable in Phase 1 — the bag only ever
        // contains Normal symbols and Wild.

        // Tracks which normal symbol the run is currently matching; nil while every cell seen
        // so far has been Wild. Only used to decide how long the run extends — the payout
        // lookup always uses `firstCellID`'s symbol (see StrikeResult.payout doc above).
        var matchAnchor: Int? = firstCellID == bag.wild.id ? nil : firstCellID
        var hits = 1

        for cellIndex in payline.cells.dropFirst() {
            guard let cellSymbolID = matrix.cells[cellIndex] else { break }

            if cellSymbolID == bag.wild.id {
                hits += 1
                continue
            }

            if let anchor = matchAnchor {
                guard cellSymbolID == anchor else { break }
                hits += 1
            } else {
                matchAnchor = cellSymbolID
                hits += 1
            }
        }

        let payoutSymbol = bag.symbol(withID: firstCellID)
        let payout = payoutSymbol?.payoutTable.payout(forHits: hits) ?? 0
        return StrikeResult(payline: payline, hits: hits, payout: payout)
    }
}
