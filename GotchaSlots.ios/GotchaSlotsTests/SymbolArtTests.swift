import XCTest
import UIKit
@testable import GotchaSlotsIOS

/// Confirms Phase 7's asset-catalog import actually resolves at runtime — every assetName every
/// machine's config references should load a real `UIImage`, not silently fall back to
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

    func testEveryMachineAssetName_resolvesToARealImage() {
        let catalog = MachineCatalog.loadAll()
        XCTAssertEqual(catalog.count, 42, "expected the full 42-machine catalog")

        for machine in catalog {
            var assetNames = machine.normalSymbols.map(\.assetName)
            assetNames.append(machine.wild.assetName)
            for special in [
                machine.freeSpins, machine.bomb, machine.miniSpin, machine.bonusGame,
                machine.multiplier, machine.ace, machine.gold, machine.king,
            ] {
                if let special { assetNames.append(special.assetName) }
            }
            for name in assetNames {
                XCTAssertNotNil(
                    UIImage(named: name),
                    "no image found for asset '\(name)' (machine '\(machine.machineName)', \(machine.gridShape))"
                )
            }
        }
    }

    func testEveryMachineName_resolvesToALobbyThumbnail() {
        let catalog = MachineCatalog.loadAll()
        let uniqueMachineNames = Set(catalog.map(\.machineName))
        XCTAssertEqual(uniqueMachineNames.count, 21, "expected 21 unique machine skins")

        for name in uniqueMachineNames {
            XCTAssertNotNil(UIImage(named: "\(name)_Thumbnail"), "no lobby thumbnail found for '\(name)'")
        }
    }
}
