import XCTest
import UIKit
@testable import GotchaSlotsIOS

/// Confirms Phase 7's asset-catalog import actually resolves at runtime — every assetName the
/// Classic config references should load a real `UIImage`, not silently fall back to
/// SymbolNode's placeholder rendering.
final class SymbolArtTests: XCTestCase {
    func testEveryClassicAssetName_resolvesToARealImage() throws {
        let machine = try MachineConfigurationLoader.load(named: "classic_5x3")

        var assetNames = machine.normalSymbols.map(\.assetName)
        assetNames.append(machine.wild.assetName)
        for special in [machine.freeSpins, machine.bomb, machine.miniSpin, machine.bonusGame, machine.multiplier] {
            if let special { assetNames.append(special.assetName) }
        }

        XCTAssertEqual(assetNames.count, 16, "expected 10 normal symbols + wild + 5 specials")
        for name in assetNames {
            XCTAssertNotNil(UIImage(named: name), "no image found for asset '\(name)'")
        }
    }
}
