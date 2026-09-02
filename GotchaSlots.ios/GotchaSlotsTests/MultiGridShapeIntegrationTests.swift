import XCTest
@testable import GotchaSlotsIOS

/// Proves the engine (ResultMatrixGenerator, StrikeEvaluator, WinEvaluatorChain, SpinResolver)
/// is genuinely grid-shape-generic, not just 5x3-shaped code that happens to compile for other
/// shapes. Exercises the full spin pipeline against every shape's real payline table.
final class MultiGridShapeIntegrationTests: XCTestCase {
    let symbol0 = SymbolConfig(id: 0, assetName: "s0", payoutTable: PayoutTable(payoutByHits: [5: 22, 4: 11, 3: 5, 2: 0]))
    let symbol1 = SymbolConfig(id: 1, assetName: "s1", payoutTable: PayoutTable(payoutByHits: [5: 16, 4: 10, 3: 5, 2: 0]))
    let wild = SymbolConfig(id: 2, assetName: "wild", payoutTable: PayoutTable(payoutByHits: [5: 20, 4: 15, 3: 10, 2: 5]))

    lazy var bag = SymbolBag(normalSymbols: [symbol0, symbol1], wild: wild, factor: 1.0)

    // All win mechanics enabled, to prove the full Phase 3 valuator chain (not just Strike) is
    // grid-shape-generic. The bag has no special symbols configured, so Symetric/Column/Strike
    // are the only ones that can actually produce results here — BonusGame/scatter evaluators
    // simply no-op (guarded by `if let` on the optional special symbols), which is itself part
    // of what's being verified: enabling a flag with no matching symbol must not crash.
    let allFeatures = MachineFeatureFlags(
        strikeValuator: true, freeSpinsScatterValuator: true, bombScatterValuator: true,
        miniSpinScatterValuator: true, collectiblesScatterValuator: true, bonusGameValuator: true,
        columnValuator: true, symetricValuator: true, multiplierScatterValuator: true
    )

    func testEveryGridShape_producesAFullyEvaluatedResult() {
        for shape in [GridShape.grid3x3, .grid5x1, .grid5x3, .grid5x4, .grid5x5] {
            let paylines = PaylineSet.all(for: shape)
            XCTAssertFalse(paylines.isEmpty, "\(shape) has no paylines")

            let matrix = ResultMatrixGenerator.generate(bag: bag, gridShape: shape)
            XCTAssertEqual(matrix.cells.count, shape.cellCount, "\(shape) grid not fully filled")

            // Every payline's cell indices must be valid positions in this shape's grid —
            // catches a shape/table mismatch (e.g. accidentally pairing 5x4 paylines with a
            // 3x3 grid) that unit tests on either piece alone wouldn't surface.
            for line in paylines {
                for cell in line.cells {
                    XCTAssertTrue((0..<shape.cellCount).contains(cell), "\(shape) payline \(line.id) cell \(cell) out of bounds")
                }
            }

            let payout = WinEvaluatorChain.calculatePayout(
                matrix: matrix, gridShape: shape, paylines: paylines, bag: bag,
                features: allFeatures, selectedPaylines: paylines.count, selectedBetChips: 1.0
            )
            XCTAssertGreaterThanOrEqual(payout.totalChips, 0, "\(shape) produced a negative payout")
            // selectedBetChips is 1.0, so chip-earning evaluators contribute equally to both
            // totals; trigger-only evaluators (Bomb/MiniSpin/FreeSpins/collectibles) only add
            // to totalPayout — so totalPayout can never be less than totalChips.
            XCTAssertGreaterThanOrEqual(payout.totalPayout, payout.totalChips, "\(shape) totalPayout should be >= totalChips")
        }
    }

    func testSpinResolver_worksForA3x3Machine() {
        let paylines = PaylineSet.all(for: .grid3x3)
        let machine = MachineConfiguration(
            id: 1, machineName: "Test3x3", gridShape: .grid3x3,
            normalSymbols: [symbol0, symbol1], wild: wild, factor: 1.0,
            maxPaylines: paylines.count, openOnLevel: 1, isComingSoon: false, depreciationRatio: 0.8,
            features: MachineFeatureFlags(
                strikeValuator: true, freeSpinsScatterValuator: false, bombScatterValuator: false,
                miniSpinScatterValuator: false, collectiblesScatterValuator: false, bonusGameValuator: false,
                columnValuator: false, symetricValuator: false, multiplierScatterValuator: false
            )
        )
        let resolver = SpinResolver(machine: machine, bag: bag, paylines: paylines, diagonalWinLimitChips: 500)

        for _ in 0..<20 {
            let result = resolver.resolve(selectedPaylines: paylines.count, selectedBetChips: 1.0)
            XCTAssertEqual(result.matrix.cells.count, GridShape.grid3x3.cellCount)
        }
    }
}
