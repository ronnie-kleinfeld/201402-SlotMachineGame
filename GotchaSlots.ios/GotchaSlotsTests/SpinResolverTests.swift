import XCTest
@testable import GotchaSlotsIOS

final class SpinResolverTests: XCTestCase {
    func testResolve_alwaysReturnsAFullyEvaluatedResult() {
        // classic_5x3.json is the real Phase 1 fixture; loading it here doubles as a decode
        // smoke test for MachineConfiguration/PayoutTable's Codable conformance.
        let data = classicJSONFixture.data(using: .utf8)!
        let machine = try! MachineConfigurationLoader.load(from: data)
        let bag = SymbolBag(
            normalSymbols: machine.normalSymbols, wild: machine.wild, factor: machine.factor,
            freeSpins: machine.freeSpins, bomb: machine.bomb, miniSpin: machine.miniSpin,
            bonusGame: machine.bonusGame, multiplier: machine.multiplier
        )
        let resolver = SpinResolver(machine: machine, bag: bag, paylines: paylines5x3, diagonalWinLimitChips: 1000)

        for _ in 0..<20 {
            let result = resolver.resolve(selectedPaylines: 20, selectedBetChips: 1.0)
            XCTAssertEqual(result.matrix.cells.count, machine.gridShape.cellCount)
            XCTAssertGreaterThanOrEqual(result.payout.totalChips, 0)
        }
    }

    private func makeMachineAndResolver() -> (MachineConfiguration, SymbolBag, SpinResolver) {
        let data = classicJSONFixture.data(using: .utf8)!
        let machine = try! MachineConfigurationLoader.load(from: data)
        let bag = SymbolBag(
            normalSymbols: machine.normalSymbols, wild: machine.wild, factor: machine.factor,
            freeSpins: machine.freeSpins, bomb: machine.bomb, miniSpin: machine.miniSpin,
            bonusGame: machine.bonusGame, multiplier: machine.multiplier
        )
        let resolver = SpinResolver(machine: machine, bag: bag, paylines: paylines5x3, diagonalWinLimitChips: 1000)
        return (machine, bag, resolver)
    }

    /// A grid5x3 matrix (5 columns, 3 rows) filled with distinct sentinel values, so a gravity
    /// shift's cell movement can be verified by exact identity rather than just "changed".
    private func sentinelMatrix() -> ResultMatrix {
        var cells: [Int: Int] = [:]
        for i in 0..<15 { cells[i] = 1000 + i }
        return ResultMatrix(cells: cells, gridShape: .grid5x3)
    }

    func testApplyBombAndMiniSpinIfNeeded_bombGravityShiftsItsColumnAndRefillsTop() {
        let (machine, _, resolver) = makeMachineAndResolver()
        var matrix = sentinelMatrix()
        // Column 2, row 2 (bottom row) — cell index 2*5+2 = 12.
        let bombCellIndex = 12
        matrix.cells[bombCellIndex] = machine.bomb!.id
        let payout = WinEvaluatorChain.calculatePayout(
            matrix: matrix, gridShape: .grid5x3, paylines: paylines5x3, bag: resolver.bag,
            features: machine.features, selectedPaylines: 20, selectedBetChips: 1.0
        )
        let result = resolver.applyBombAndMiniSpinIfNeeded(
            to: SpinResult(matrix: matrix, payout: payout), selectedPaylines: 20, selectedBetChips: 1.0
        )

        // Row 1's value (originally 1007, cell index 1*5+2=7) shifted down into the bomb's cell.
        XCTAssertEqual(result.matrix.cells[bombCellIndex], 1007)
        // Row 0's value (originally 1002, cell index 2) shifted down into row 1.
        XCTAssertEqual(result.matrix.cells[7], 1002)
        // Row 0 itself was refilled with a fresh normal symbol, not left empty or a sentinel.
        let normalSymbolIDs = Set(machine.normalSymbols.map(\.id))
        XCTAssertTrue(normalSymbolIDs.contains(result.matrix.cells[2] ?? -1))
        // The bomb symbol itself is gone from the board.
        XCTAssertFalse(result.matrix.cells.values.contains(machine.bomb!.id))
    }

    func testApplyBombAndMiniSpinIfNeeded_miniSpinRedrawsOnlyThatCellToANormalSymbol() {
        let (machine, _, resolver) = makeMachineAndResolver()
        var matrix = sentinelMatrix()
        let miniSpinCellIndex = 5
        matrix.cells[miniSpinCellIndex] = machine.miniSpin!.id
        let payout = WinEvaluatorChain.calculatePayout(
            matrix: matrix, gridShape: .grid5x3, paylines: paylines5x3, bag: resolver.bag,
            features: machine.features, selectedPaylines: 20, selectedBetChips: 1.0
        )
        let result = resolver.applyBombAndMiniSpinIfNeeded(
            to: SpinResult(matrix: matrix, payout: payout), selectedPaylines: 20, selectedBetChips: 1.0
        )

        let normalSymbolIDs = Set(machine.normalSymbols.map(\.id))
        XCTAssertTrue(normalSymbolIDs.contains(result.matrix.cells[miniSpinCellIndex] ?? -1))
        // Every other cell is untouched — MiniSpin redraws only the cell(s) it occupied.
        for i in 0..<15 where i != miniSpinCellIndex {
            XCTAssertEqual(result.matrix.cells[i], 1000 + i)
        }
    }

    func testApplyBombAndMiniSpinIfNeeded_noTrigger_returnsResultUnchanged() {
        let (machine, _, resolver) = makeMachineAndResolver()
        let matrix = sentinelMatrix() // no bomb/miniSpin symbol anywhere
        let payout = WinEvaluatorChain.calculatePayout(
            matrix: matrix, gridShape: .grid5x3, paylines: paylines5x3, bag: resolver.bag,
            features: machine.features, selectedPaylines: 20, selectedBetChips: 1.0
        )
        let original = SpinResult(matrix: matrix, payout: payout)
        let result = resolver.applyBombAndMiniSpinIfNeeded(to: original, selectedPaylines: 20, selectedBetChips: 1.0)

        XCTAssertEqual(result.matrix.cells, original.matrix.cells)
    }
}

/// Mirrors Resources/MachineConfigs/classic_5x3.json — kept inline so the test target doesn't
/// depend on the app target's resource bundling.
private let classicJSONFixture = """
{
  "id": 0,
  "machineName": "Classic",
  "gridShape": "grid5x3",
  "factor": 1.0,
  "maxPaylines": 100,
  "openOnLevel": 150,
  "isComingSoon": false,
  "depreciationRatio": 0.80,
  "normalSymbols": [
    { "id": 0, "assetName": "Classic_Symbol_01", "payoutTable": { "payoutByHits": { "5": 22,  "4": 11,  "3": 5,  "2": 0 } } },
    { "id": 1, "assetName": "Classic_Symbol_02", "payoutTable": { "payoutByHits": { "5": 16,  "4": 10,  "3": 5,  "2": 0 } } },
    { "id": 2, "assetName": "Classic_Symbol_03", "payoutTable": { "payoutByHits": { "5": 23,  "4": 20,  "3": 10, "2": 5 } } },
    { "id": 3, "assetName": "Classic_Symbol_04", "payoutTable": { "payoutByHits": { "5": 31,  "4": 21,  "3": 8,  "2": 5 } } },
    { "id": 4, "assetName": "Classic_Symbol_05", "payoutTable": { "payoutByHits": { "5": 32,  "4": 25,  "3": 10, "2": 8 } } },
    { "id": 5, "assetName": "Classic_Symbol_06", "payoutTable": { "payoutByHits": { "5": 42,  "4": 24,  "3": 13, "2": 11 } } },
    { "id": 6, "assetName": "Classic_Symbol_07", "payoutTable": { "payoutByHits": { "5": 57,  "4": 23,  "3": 13, "2": 12 } } },
    { "id": 7, "assetName": "Classic_Symbol_08", "payoutTable": { "payoutByHits": { "5": 145, "4": 97,  "3": 55, "2": 21 } } },
    { "id": 8, "assetName": "Classic_Symbol_09", "payoutTable": { "payoutByHits": { "5": 150, "4": 85,  "3": 54, "2": 30 } } },
    { "id": 9, "assetName": "Classic_Symbol_10", "payoutTable": { "payoutByHits": { "5": 152, "4": 109, "3": 66, "2": 41 } } }
  ],
  "wild": {
    "id": 10,
    "assetName": "Classic_Wild",
    "payoutTable": { "payoutByHits": { "5": 20, "4": 15, "3": 10, "2": 5 } }
  },
  "features": {
    "strikeValuator": true,
    "freeSpinsScatterValuator": true,
    "bombScatterValuator": true,
    "miniSpinScatterValuator": true,
    "collectiblesScatterValuator": false,
    "bonusGameValuator": true,
    "columnValuator": true,
    "symetricValuator": true,
    "multiplierScatterValuator": true
  },
  "freeSpins": { "id": 11, "assetName": "Classic_FreeSpins", "payoutTable": { "payoutByHits": { "5": 7, "4": 5, "3": 3, "2": 2 } } },
  "bomb": { "id": 12, "assetName": "Classic_Bomb", "payoutTable": { "payoutByHits": { "5": 1, "4": 1, "3": 1, "2": 1, "1": 1 } } },
  "miniSpin": { "id": 13, "assetName": "Classic_MiniSpin", "payoutTable": { "payoutByHits": { "5": 1, "4": 1, "3": 1, "2": 1, "1": 1 } } },
  "bonusGame": { "id": 14, "assetName": "Classic_BonusGame", "payoutTable": { "payoutByHits": { "5": 20, "4": 15, "3": 10, "2": 5 } } },
  "multiplier": { "id": 15, "assetName": "Classic_Multiplier", "payoutTable": { "payoutByHits": { "5": 5, "4": 4, "3": 3, "2": 2, "1": 1 } } }
}
"""
