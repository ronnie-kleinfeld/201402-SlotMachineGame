import Foundation

/// A resolved spin: the grid that was drawn plus its computed payout.
struct SpinResult {
    let matrix: ResultMatrix
    let payout: SpinPayout
}

/// Abstraction boundary for "how a spin's outcome is decided," so a server-authoritative
/// implementation could be swapped in later (see the plan's Decision A) without touching
/// SpinStateMachine or any presentation code.
protocol SpinResolving {
    func resolve(selectedPaylines: Int, selectedBetChips: Double) -> SpinResult
}

/// Ports ResultMatrixHandler.GetResultMatrix(): client-side RTP-shaping via reject-sampling.
/// Rather than a flat/uniform RNG, this repeatedly generates candidate grids and only accepts
/// one that falls in a randomly chosen payout band, so win frequency/size is deliberately
/// shaped rather than a direct consequence of the base symbol odds.
final class SpinResolver: SpinResolving {
    /// Ports `RESULT_MATRIX_LIMIT`.
    private static let matrixLimit = 50
    /// Ports `RESULT_MATRIX_LIMIT * 5` — the fallback loop's ceiling, continuing the same
    /// counter rather than resetting it, so at most 250 total candidates are drawn.
    private static let fallbackLimit = 50 * 5

    let machine: MachineConfiguration
    let bag: SymbolBag
    let paylines: [Payline]
    /// Ports `Main.Instance.Session.Wallet.DiagonalWinLimitChips` — the session-level cap on
    /// how large a "big win" tier result is allowed to be. Phase 1 takes this as a parameter
    /// since the wallet/session layer doesn't exist until Phase 5.
    let diagonalWinLimitChips: Double

    init(machine: MachineConfiguration, bag: SymbolBag, paylines: [Payline], diagonalWinLimitChips: Double) {
        self.machine = machine
        self.bag = bag
        self.paylines = paylines
        self.diagonalWinLimitChips = diagonalWinLimitChips
    }

    private func evaluate(matrix: ResultMatrix, selectedPaylines: Int, selectedBetChips: Double) -> SpinPayout {
        WinEvaluatorChain.calculatePayout(
            matrix: matrix,
            gridShape: machine.gridShape,
            paylines: paylines,
            bag: bag,
            features: machine.features,
            selectedPaylines: selectedPaylines,
            selectedBetChips: selectedBetChips
        )
    }

    private func candidate(selectedPaylines: Int, selectedBetChips: Double) -> SpinResult {
        let matrix = ResultMatrixGenerator.generate(
            bag: bag,
            gridShape: machine.gridShape,
            bombSymbolID: bag.bomb?.id,
            freeSpinsSymbolID: bag.freeSpins?.id
        )
        let payout = evaluate(matrix: matrix, selectedPaylines: selectedPaylines, selectedBetChips: selectedBetChips)
        return SpinResult(matrix: matrix, payout: payout)
    }

    func resolve(selectedPaylines: Int, selectedBetChips: Double) -> SpinResult {
        let totalBetChips = selectedBetChips * Double(selectedPaylines)
        // Ports `Math.ceil(Math.random() * 100)` — a discrete 1...100 draw.
        let probability = Int.random(in: 1...100)

        var active: SpinResult?
        var counter = 0

        while active == nil && counter < Self.matrixLimit {
            let current = candidate(selectedPaylines: selectedPaylines, selectedBetChips: selectedBetChips)
            let chips = current.payout.totalChips

            if probability <= 25 {
                // 25% band: chips land strictly between totalBet and the diagonal win limit
                // (whichever order those two are in).
                let lower = min(totalBetChips, diagonalWinLimitChips)
                let upper = max(totalBetChips, diagonalWinLimitChips)
                if chips > lower && chips <= upper {
                    active = current
                }
            } else if probability <= 75 {
                // 50% band: an ordinary win at or under total bet.
                if chips <= totalBetChips {
                    active = current
                }
            } else {
                // 25% band: force a loss. If this candidate happens to already be valuable
                // (a real win OR a trigger-only result like Bomb/FreeSpins), discard and retry;
                // otherwise decorate the guaranteed loss with consolation bomb/mini-spin/
                // multiplier features and recalculate payout.
                if !current.payout.isValuable {
                    active = decorateConsolationLoss(current, selectedPaylines: selectedPaylines, selectedBetChips: selectedBetChips)
                }
            }
            counter += 1
        }

        if active == nil {
            var fallbackCandidate: SpinResult?
            while fallbackCandidate == nil && counter < Self.fallbackLimit {
                let current = candidate(selectedPaylines: selectedPaylines, selectedBetChips: selectedBetChips)
                if current.payout.isValuable {
                    // discard, keep looking
                } else {
                    fallbackCandidate = current
                }
                counter += 1
            }
            active = fallbackCandidate
        }

        return active ?? candidate(selectedPaylines: selectedPaylines, selectedBetChips: selectedBetChips)
    }

    /// Ports BaseResultMatirxData.AddRandomBomb/AddRandomMiniSpins/AddRandomMultiplier +
    /// ResultMatrixHandler's call to ReCalculatePayout: plants consolation symbols into an
    /// already-generated LOSING grid, each attempt independently gated by that symbol's own
    /// IsRandomOdds probability (so this can plant zero, some, or all of them), then
    /// re-evaluates payout from scratch. MiniSpin gets 5 independent attempts (ports the AS3
    /// `for i in 0..<5` loop); Bomb and Multiplier get 1 each.
    private func decorateConsolationLoss(_ result: SpinResult, selectedPaylines: Int, selectedBetChips: Double) -> SpinResult {
        var matrix = result.matrix

        if let bomb = bag.bomb, SymbolBag.isRandomOdds(specialOdds: bag.bombSpecialOdds) {
            plantRandomSymbol(bomb.id, in: &matrix)
        }
        if let miniSpin = bag.miniSpin {
            for _ in 0..<5 where SymbolBag.isRandomOdds(specialOdds: bag.miniSpinSpecialOdds) {
                plantRandomSymbol(miniSpin.id, in: &matrix)
            }
        }
        if let multiplier = bag.multiplier, SymbolBag.isRandomOdds(specialOdds: bag.multiplierSpecialOdds) {
            plantRandomSymbol(multiplier.id, in: &matrix)
        }

        let payout = evaluate(matrix: matrix, selectedPaylines: selectedPaylines, selectedBetChips: selectedBetChips)
        return SpinResult(matrix: matrix, payout: payout)
    }

    private func plantRandomSymbol(_ symbolID: Int, in matrix: inout ResultMatrix) {
        let cellIndex = Int.random(in: 0..<matrix.gridShape.cellCount)
        matrix.cells[cellIndex] = symbolID
    }
}
