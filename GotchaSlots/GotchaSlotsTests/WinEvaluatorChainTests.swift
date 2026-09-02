import XCTest
@testable import GotchaSlots

final class WinEvaluatorChainTests: XCTestCase {
    let symbol0 = SymbolConfig(id: 0, assetName: "s0", payoutTable: PayoutTable(payoutByHits: [5: 22, 4: 11, 3: 5, 2: 0]))
    let symbol1 = SymbolConfig(id: 1, assetName: "s1", payoutTable: PayoutTable(payoutByHits: [5: 16, 4: 10, 3: 5, 2: 0]))
    let wild = SymbolConfig(id: 2, assetName: "wild", payoutTable: PayoutTable(payoutByHits: [5: 20, 4: 15, 3: 10, 2: 5]))

    lazy var bag = SymbolBag(normalSymbols: [symbol0, symbol1], wild: wild, factor: 1.0)

    // Strike-only feature set — these tests predate Phase 3's fuller valuator chain and are
    // deliberately scoped to just StrikeEvaluator (see MultiGridShapeIntegrationTests and the
    // Phase-3-specific evaluator test files for symetric/column/bonus/scatter coverage).
    let strikeOnlyFeatures = MachineFeatureFlags(
        strikeValuator: true, freeSpinsScatterValuator: false, bombScatterValuator: false,
        miniSpinScatterValuator: false, collectiblesScatterValuator: false, bonusGameValuator: false,
        columnValuator: false, symetricValuator: false, multiplierScatterValuator: false
    )

    func testOnlyPaylinesWithinSelectedCount_contributeToPayout() {
        // Two winning paylines (both all-symbol0, 5 hits = payout 22 each), grid is a single
        // row repeated so both paylines read the same winning cells.
        var cells: [Int: Int] = [:]
        for i in 0..<15 { cells[i] = 0 } // all cells = symbol0, guarantees every line wins
        let matrix = ResultMatrix(cells: cells, gridShape: .grid5x3)

        let line0 = Payline(id: 0, color: 0, cells: [0, 1, 2, 3, 4])
        let line1 = Payline(id: 1, color: 0, cells: [5, 6, 7, 8, 9])
        let line2 = Payline(id: 2, color: 0, cells: [10, 11, 12, 13, 14])

        // selectedPaylines = 2 -> only line0 and line1 (array order = ID order) pay, even
        // though line2 also won — ports BaseValuatorsData.CalculatePaylinesPayout's `for i in
        // 0..<selectedPaylines` loop.
        let payout = WinEvaluatorChain.calculatePayout(
            matrix: matrix, gridShape: .grid5x3, paylines: [line0, line1, line2], bag: bag,
            features: strikeOnlyFeatures, selectedPaylines: 2, selectedBetChips: 1.0
        )

        XCTAssertEqual(payout.totalPayout, 44) // 22 + 22, line2 excluded
        XCTAssertEqual(payout.totalChips, 44)
        XCTAssertTrue(payout.isValuable)
    }

    func testChipsScaleWithSelectedBetChips() {
        var cells: [Int: Int] = [:]
        for i in 0..<5 { cells[i] = 0 }
        let matrix = ResultMatrix(cells: cells, gridShape: .grid5x3)
        let line0 = Payline(id: 0, color: 0, cells: [0, 1, 2, 3, 4])

        let payout = WinEvaluatorChain.calculatePayout(
            matrix: matrix, gridShape: .grid5x3, paylines: [line0], bag: bag,
            features: strikeOnlyFeatures, selectedPaylines: 1, selectedBetChips: 2.5
        )

        XCTAssertEqual(payout.totalPayout, 22)
        XCTAssertEqual(payout.totalChips, 55) // 22 * 2.5
    }

    func testNoWin_isNotValuable() {
        // symbol0, symbol1, symbol0, symbol1, symbol0 -> the run breaks at column 1 (a genuine
        // mismatch, not Wild), leaving hits=1, which is below symbol0's minimum-hits-to-pay (3).
        let cells: [Int: Int] = [0: 0, 1: 1, 2: 0, 3: 1, 4: 0]
        let matrix = ResultMatrix(cells: cells, gridShape: .grid5x3)
        let line0 = Payline(id: 0, color: 0, cells: [0, 1, 2, 3, 4])

        let payout = WinEvaluatorChain.calculatePayout(
            matrix: matrix, gridShape: .grid5x3, paylines: [line0], bag: bag,
            features: strikeOnlyFeatures, selectedPaylines: 1, selectedBetChips: 1.0
        )

        XCTAssertFalse(payout.isValuable)
        XCTAssertEqual(payout.totalChips, 0)
    }
}
