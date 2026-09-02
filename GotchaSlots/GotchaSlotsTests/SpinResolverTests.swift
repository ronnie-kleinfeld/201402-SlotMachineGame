import XCTest
@testable import GotchaSlots

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
