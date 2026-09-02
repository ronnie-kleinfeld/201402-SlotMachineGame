import XCTest
@testable import GotchaSlotsIOS

/// Covers the subtlest part of Phase 3: which evaluators contribute real Chips vs only a
/// Payout coefficient (trigger detection). Confirmed by reading every valuator's
/// CalculatePaylinesPayout override (or lack of one) in the AS3 source — see WinEvaluatorChain's
/// doc comment for the full reasoning.
final class WinEvaluatorChainPhase3Tests: XCTestCase {
    let symbol0 = SymbolConfig(id: 0, assetName: "s0", payoutTable: PayoutTable(payoutByHits: [5: 22, 4: 11, 3: 5, 2: 0]))
    let wild = SymbolConfig(id: 1, assetName: "wild", payoutTable: PayoutTable(payoutByHits: [5: 20, 4: 15, 3: 10, 2: 5]))
    let bomb = SymbolConfig(id: 2, assetName: "bomb", payoutTable: PayoutTable(payoutByHits: [5: 1, 4: 1, 3: 1, 2: 1, 1: 1]))
    let multiplier = SymbolConfig(id: 3, assetName: "mult", payoutTable: PayoutTable(payoutByHits: [5: 5, 4: 4, 3: 3, 2: 2, 1: 1]))

    func testBombTrigger_contributesToPayoutButNotChips() {
        let bag = SymbolBag(normalSymbols: [symbol0], wild: wild, factor: 1.0, bomb: bomb)
        // One bomb symbol on the grid, no strike wins otherwise.
        var cells: [Int: Int] = [:]
        for i in 0..<15 { cells[i] = 0 }
        cells[7] = bomb.id // lone bomb somewhere off any winning strike run
        let matrix = ResultMatrix(cells: cells, gridShape: .grid5x3)

        let features = MachineFeatureFlags(
            strikeValuator: false, freeSpinsScatterValuator: false, bombScatterValuator: true,
            miniSpinScatterValuator: false, collectiblesScatterValuator: false, bonusGameValuator: false,
            columnValuator: false, symetricValuator: false, multiplierScatterValuator: false
        )
        let payout = WinEvaluatorChain.calculatePayout(
            matrix: matrix, gridShape: .grid5x3, paylines: paylines5x3, bag: bag,
            features: features, selectedPaylines: 20, selectedBetChips: 5.0
        )

        XCTAssertTrue(payout.isBombTriggered)
        XCTAssertGreaterThan(payout.totalPayout, 0) // contributes to Payout (trigger detection)
        XCTAssertEqual(payout.totalChips, 0) // but NOT to Chips — bomb isn't a direct cash payout
    }

    func testMultiplierTrigger_doesContributeRealChips() {
        // Multiplier is the one scatter type whose CalculatePaylinesPayout IS overridden to
        // set Chips = Payout * selectedBetChips.
        let bag = SymbolBag(normalSymbols: [symbol0], wild: wild, factor: 1.0, multiplier: multiplier)
        var cells: [Int: Int] = [:]
        for i in 0..<15 { cells[i] = 0 }
        cells[7] = multiplier.id
        cells[8] = multiplier.id
        let matrix = ResultMatrix(cells: cells, gridShape: .grid5x3)

        let features = MachineFeatureFlags(
            strikeValuator: false, freeSpinsScatterValuator: false, bombScatterValuator: false,
            miniSpinScatterValuator: false, collectiblesScatterValuator: false, bonusGameValuator: false,
            columnValuator: false, symetricValuator: false, multiplierScatterValuator: true
        )
        let payout = WinEvaluatorChain.calculatePayout(
            matrix: matrix, gridShape: .grid5x3, paylines: paylines5x3, bag: bag,
            features: features, selectedPaylines: 20, selectedBetChips: 5.0
        )

        XCTAssertTrue(payout.isMultiplierTriggered)
        // 2 hits -> payout coefficient 2, chips = 2 * 5.0 = 10.
        XCTAssertEqual(payout.totalPayout, 2)
        XCTAssertEqual(payout.totalChips, 10)
    }

    func testDisabledFeatureFlag_producesNoResultEvenIfSymbolIsOnGrid() {
        // bombScatterValuator is false -> Bomb must be completely ignored, even though the bag
        // has a bomb symbol configured and it's physically present on the grid.
        let bag = SymbolBag(normalSymbols: [symbol0], wild: wild, factor: 1.0, bomb: bomb)
        var cells: [Int: Int] = [:]
        for i in 0..<15 { cells[i] = 0 }
        cells[7] = bomb.id
        let matrix = ResultMatrix(cells: cells, gridShape: .grid5x3)

        let features = MachineFeatureFlags(
            strikeValuator: false, freeSpinsScatterValuator: false, bombScatterValuator: false,
            miniSpinScatterValuator: false, collectiblesScatterValuator: false, bonusGameValuator: false,
            columnValuator: false, symetricValuator: false, multiplierScatterValuator: false
        )
        let payout = WinEvaluatorChain.calculatePayout(
            matrix: matrix, gridShape: .grid5x3, paylines: paylines5x3, bag: bag,
            features: features, selectedPaylines: 20, selectedBetChips: 5.0
        )

        XCTAssertFalse(payout.isBombTriggered)
        XCTAssertNil(payout.bombResult)
        XCTAssertEqual(payout.totalPayout, 0)
    }

    func testFiveInARow_detectedOnlyOnHorizontalPaylines() {
        let bag = SymbolBag(normalSymbols: [symbol0], wild: wild, factor: 1.0)
        var cells: [Int: Int] = [:]
        for i in 0..<15 { cells[i] = 1 } // fill with wild everywhere except row 0
        for i in 0..<5 { cells[i] = 0 } // row 0 (payline ID 0 or 1, a horizontal line) = all symbol0
        let matrix = ResultMatrix(cells: cells, gridShape: .grid5x3)

        let features = MachineFeatureFlags(
            strikeValuator: true, freeSpinsScatterValuator: false, bombScatterValuator: false,
            miniSpinScatterValuator: false, collectiblesScatterValuator: false, bonusGameValuator: false,
            columnValuator: false, symetricValuator: false, multiplierScatterValuator: false
        )
        let payout = WinEvaluatorChain.calculatePayout(
            matrix: matrix, gridShape: .grid5x3, paylines: paylines5x3, bag: bag,
            features: features, selectedPaylines: paylines5x3.count, selectedBetChips: 1.0
        )

        XCTAssertTrue(payout.isFiveInARow(gridShape: .grid5x3))
        XCTAssertFalse(payout.isFourInARow(gridShape: .grid5x3))
    }
}
