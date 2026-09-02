import Foundation

/// Ports BaseResultMatirxData's constructor: fills the grid one row at a time from a "pivot"
/// symbol, biasing early columns toward repeating the pivot with decaying probability toward
/// the last column — the actual "reel strip" of this game (there's no fixed symbol sequence
/// per reel; every cell is drawn independently, weighted toward looking like a near-miss).
struct ResultMatrix {
    /// Cell index -> symbol ID, row-major (index = row * columns + column) — matches PayboxData's
    /// indexing convention in every Paylines{Shape}Data.as source file (5x3, 3x3, 5x1, 5x4, 5x5).
    var cells: [Int: Int]
    let gridShape: GridShape
}

enum ResultMatrixGenerator {
    /// Ports BaseResultMatirxData's grid-fill loop (lines 81-112 of the AS3 source).
    /// `bombSymbolID`/`freeSpinsSymbolID` are optional since Phase 1's SymbolBag doesn't carry
    /// them yet (StrikeEvaluator-only scope) — the guards below still run and simply no-op
    /// when those IDs are nil, so this class doesn't need revisiting once Phase 3 adds them.
    static func generate(
        bag: SymbolBag,
        gridShape: GridShape,
        bombSymbolID: Int? = nil,
        freeSpinsSymbolID: Int? = nil
    ) -> ResultMatrix {
        var cells: [Int: Int] = [:]
        var counter = 0
        // Ports AS3 `var hasBomb:Boolean;` — declared but never assigned true anywhere in the
        // original constructor, so the duplicate-bomb guard below is dead code in the source
        // game too. Reproduced faithfully (not "fixed") rather than silently changing game feel.
        let hasBomb = false
        let rows = gridShape.rows
        let columns = gridShape.columns

        for _ in 0..<rows {
            let pivotRandomID = bag.randomID
            for columnIndex in 0..<columns {
                var randomID: Int
                // Ports `var probability:int = Math.random() * 100;` — AS3 truncates the
                // Number to int on assignment, so this must be a discrete 0...99 draw, not a
                // continuous one, to match the threshold comparison below exactly.
                let probability = Double(Int(Double.random(in: 0..<100)))

                if columnIndex == 0 || probability <= 50.0 * Double(columns - columnIndex) / Double(columns) {
                    randomID = pivotRandomID
                } else {
                    randomID = bag.randomID
                }

                if let bombSymbolID, randomID == bombSymbolID, hasBomb {
                    randomID = bag.randomNormalID
                }
                if let freeSpinsSymbolID, pivotRandomID == freeSpinsSymbolID {
                    randomID = bag.randomID
                }

                cells[counter] = randomID
                counter += 1
            }
        }

        return ResultMatrix(cells: cells, gridShape: gridShape)
    }
}
