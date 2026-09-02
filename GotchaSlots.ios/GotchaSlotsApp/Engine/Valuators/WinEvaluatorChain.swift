import Foundation

/// Ports ValuatorsHandler: aggregates every configured win-evaluator's payout into one spin
/// total, composed per-machine via MachineFeatureFlags (mirrors InitValuatorsClass).
///
/// Two payout totals are tracked deliberately, not one — confirmed by reading ValuatorsHandler.
/// CalculatePaylinesPayout, BaseValuatorsData, and every concrete valuator's own
/// CalculatePaylinesPayout override (or lack of one):
///   - `totalPayout` sums EVERY evaluator's Payout coefficient, including trigger-only ones.
///     A valuator's Payout is set during Evaluate() and, if CalculatePaylinesPayout is never
///     overridden (Bomb/MiniSpin/FreeSpins/collectibles all inherit the BaseValuatorsData
///     no-op), that Evaluate()-computed Payout survives untouched — it still gets summed by
///     ValuatorsHandler. This is also what drives `isValuable` (`_isValuable = _isValuable ||
///     valuator.IsValuable`, and IsValuable == Payout > 0 for every valuator), so a spin with
///     ONLY a triggered Bomb/FreeSpins/etc and zero real winnings still counts as "valuable".
///   - `totalChips` sums ONLY the evaluators that explicitly compute Chips in their own
///     CalculatePaylinesPayout override: Strike, Column, Symetric, BonusGame, Multiplier.
///     Bomb, MiniSpin, FreeSpins, and the collectibles contribute zero chips — they're pure
///     triggers for other game mechanics (a bomb effect, a mini-spin re-roll, free spins,
///     a collectible counter), not a direct currency payout.
struct SpinPayout {
    let strikeResults: [StrikeResult]
    let symetricResults: [SymetricResult]
    let columnResults: [ColumnResult]
    let bonusGameResults: [BonusGameResult]
    let freeSpinsResult: ScatterResult?
    let bombResult: ScatterResult?
    let miniSpinResult: ScatterResult?
    let multiplierResult: ScatterResult?
    let aceResult: ScatterResult?
    let goldResult: ScatterResult?
    let kingResult: ScatterResult?

    let totalPayout: Double
    let totalChips: Double
    var isValuable: Bool { totalPayout > 0 }

    var isBonusGameTriggered: Bool { bonusGameResults.contains { $0.payout > 0 } }
    var isFreeSpinsTriggered: Bool { freeSpinsResult?.isValuable ?? false }
    var isBombTriggered: Bool { bombResult?.isValuable ?? false }
    var isMiniSpinTriggered: Bool { miniSpinResult?.isValuable ?? false }
    var isMultiplierTriggered: Bool { multiplierResult?.isValuable ?? false }

    /// Ports ResultMatrix{Shape}Data.IsFiveInARow: any strike result on a horizontal payline
    /// (ID < gridShape.rows, by the ID convention confirmed across every payline table) with
    /// exactly 5 hits.
    func isFiveInARow(gridShape: GridShape) -> Bool {
        strikeResults.contains { $0.payline.id < gridShape.rows && $0.hits == 5 }
    }
    /// Ports ResultMatrix{Shape}Data.IsFourInARow.
    func isFourInARow(gridShape: GridShape) -> Bool {
        strikeResults.contains { $0.payline.id < gridShape.rows && $0.hits == 4 }
    }
}

enum WinEvaluatorChain {
    static func calculatePayout(
        matrix: ResultMatrix,
        gridShape: GridShape,
        paylines: [Payline],
        bag: SymbolBag,
        features: MachineFeatureFlags,
        selectedPaylines: Int,
        selectedBetChips: Double
    ) -> SpinPayout {
        var totalPayout = 0.0
        var totalChips = 0.0

        // Strike: gated by min(selectedPaylines, all-paylines-count), summed by array position
        // regardless of win/loss (ports StrikeValuatorsData.CalculatePaylinesPayout).
        let strikeResults = features.strikeValuator
            ? StrikeEvaluator.evaluate(matrix: matrix, paylines: paylines, bag: bag)
            : []
        for result in strikeResults.prefix(selectedPaylines) {
            totalPayout += result.payout
            totalChips += result.payout * selectedBetChips
        }
        // Non-selected strike paylines still contribute their coefficient to totalPayout via
        // AS3's ValuatorsHandler.Payout being the sum over ALL configured valuators' `.Payout`
        // property — but StrikeValuatorsData.Payout is only set inside CalculatePaylinesPayout
        // (which itself is bounded by selectedPaylines), so paylines beyond the bet range never
        // update StrikeValuatorsData.Payout at all. No further action needed here.

        // Symetric: horizontal paylines only, gated by min(selectedPaylines, winning-count).
        let symetricResults: [SymetricResult]
        if features.symetricValuator {
            let horizontalPaylines = Array(paylines.prefix(gridShape.rows))
            symetricResults = SymetricEvaluator.evaluate(matrix: matrix, horizontalPaylines: horizontalPaylines, bag: bag)
            for result in symetricResults.prefix(selectedPaylines) {
                totalPayout += result.payout
                totalChips += result.payout * selectedBetChips
            }
        } else {
            symetricResults = []
        }

        // Column: NOT gated by selectedPaylines at all (ports ColumnValuatorsData.
        // CalculatePaylinesPayout, which sums every entry in _columnValuators unconditionally).
        let columnResults = features.columnValuator
            ? ColumnEvaluator.evaluate(matrix: matrix, gridShape: gridShape, bag: bag)
            : []
        for result in columnResults {
            totalPayout += result.payout
            totalChips += result.payout * selectedBetChips
        }

        // BonusGame: gated by min(selectedPaylines, all-paylines-count), summed by position.
        let bonusGameResults: [BonusGameResult]
        if features.bonusGameValuator, let bonusGameSymbol = bag.bonusGame {
            bonusGameResults = BonusGameEvaluator.evaluate(matrix: matrix, paylines: paylines, bonusGameSymbol: bonusGameSymbol)
            for result in bonusGameResults.prefix(selectedPaylines) {
                totalPayout += result.payout
                totalChips += result.payout * selectedBetChips
            }
        } else {
            bonusGameResults = []
        }

        // Multiplier: real chips, flat Payout*selectedBetChips (single grid-wide scatter, no
        // per-payline iteration — ports MultiplierValuatorData.CalculatePaylinesPayout, the one
        // scatter type that DOES override it).
        var multiplierResult: ScatterResult?
        if features.multiplierScatterValuator, let multiplierSymbol = bag.multiplier {
            let result = ScatterEvaluator.evaluate(matrix: matrix, symbol: multiplierSymbol)
            multiplierResult = result
            totalPayout += result.payout
            totalChips += result.payout * selectedBetChips
        }

        // FreeSpins/Bomb/MiniSpin/collectibles: trigger-only, contribute to totalPayout (and
        // therefore isValuable) but zero chips — see SpinPayout's doc comment above.
        var freeSpinsResult: ScatterResult?
        if features.freeSpinsScatterValuator, let symbol = bag.freeSpins {
            let result = ScatterEvaluator.evaluate(matrix: matrix, symbol: symbol)
            freeSpinsResult = result
            totalPayout += result.payout
        }
        var bombResult: ScatterResult?
        if features.bombScatterValuator, let symbol = bag.bomb {
            let result = ScatterEvaluator.evaluate(matrix: matrix, symbol: symbol)
            bombResult = result
            totalPayout += result.payout
        }
        var miniSpinResult: ScatterResult?
        if features.miniSpinScatterValuator, let symbol = bag.miniSpin {
            let result = ScatterEvaluator.evaluate(matrix: matrix, symbol: symbol)
            miniSpinResult = result
            totalPayout += result.payout
        }
        var aceResult: ScatterResult?
        var goldResult: ScatterResult?
        var kingResult: ScatterResult?
        if features.collectiblesScatterValuator {
            if let symbol = bag.ace {
                let result = ScatterEvaluator.evaluate(matrix: matrix, symbol: symbol)
                aceResult = result
                totalPayout += result.payout
            }
            if let symbol = bag.gold {
                let result = ScatterEvaluator.evaluate(matrix: matrix, symbol: symbol)
                goldResult = result
                totalPayout += result.payout
            }
            if let symbol = bag.king {
                let result = ScatterEvaluator.evaluate(matrix: matrix, symbol: symbol)
                kingResult = result
                totalPayout += result.payout
            }
        }

        return SpinPayout(
            strikeResults: strikeResults,
            symetricResults: symetricResults,
            columnResults: columnResults,
            bonusGameResults: bonusGameResults,
            freeSpinsResult: freeSpinsResult,
            bombResult: bombResult,
            miniSpinResult: miniSpinResult,
            multiplierResult: multiplierResult,
            aceResult: aceResult,
            goldResult: goldResult,
            kingResult: kingResult,
            totalPayout: totalPayout,
            totalChips: totalChips
        )
    }
}
