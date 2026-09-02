import XCTest
@testable import GotchaSlotsIOS

/// Validates the full 42-machine catalog transcribed from Main.as's InitMachines() in Phase 7.
/// These configs were generated programmatically (a script over Main.as +
/// LobbyMachineNormalSymbolsData.as, the same approach used for Phase 2's paylines), so these
/// tests check structural correctness across the whole catalog rather than re-verifying every
/// individual payout number by hand — the kind of mistake a transcription script would make
/// (a missing symbol, a mismatched grid shape, a dangling bonus-game reference) is exactly what
/// these catch.
final class MachineCatalogTests: XCTestCase {
    func testCatalog_hasAllFortyTwoRealMachineEntries() {
        // Main.as's InitMachines() has 43 `_machines.push(...)` calls; one (ComingSoonDummyData)
        // isn't a real playable machine and isn't represented (see MachineCatalog's doc comment).
        let machines = MachineCatalog.loadAll()
        XCTAssertEqual(machines.count, 42)
    }

    func testEveryMachine_hasAUniqueID() {
        let machines = MachineCatalog.loadAll()
        XCTAssertEqual(Set(machines.map(\.id)).count, machines.count)
    }

    func testEveryMachine_normalSymbolsAndWildHaveDistinctIDsWithinThatMachine() {
        for machine in MachineCatalog.loadAll() {
            var ids = machine.normalSymbols.map(\.id)
            ids.append(machine.wild.id)
            XCTAssertEqual(Set(ids).count, ids.count, "\(machine.machineName) (\(machine.gridShape)) has duplicate symbol IDs")
        }
    }

    func testEveryMachine_hasAtLeastOneNormalSymbol() {
        for machine in MachineCatalog.loadAll() {
            XCTAssertFalse(machine.normalSymbols.isEmpty, "\(machine.machineName) has no normal symbols")
        }
    }

    func testEveryMachine_paylineTableForItsGridShapeIsNonEmptyAndInBounds() {
        for machine in MachineCatalog.loadAll() {
            let paylines = PaylineSet.all(for: machine.gridShape)
            XCTAssertFalse(paylines.isEmpty, "\(machine.machineName): no paylines for \(machine.gridShape)")
            XCTAssertLessThanOrEqual(machine.maxPaylines, paylines.count, "\(machine.machineName): maxPaylines exceeds the table for \(machine.gridShape)")
            for line in paylines {
                for cell in line.cells {
                    XCTAssertTrue((0..<machine.gridShape.cellCount).contains(cell), "\(machine.machineName): payline cell \(cell) out of bounds for \(machine.gridShape)")
                }
            }
        }
    }

    func testEveryMachine_featureFlagsAgreeWithConfiguredSpecialSymbols() {
        // Ports the invariant documented on MachineConfiguration: a feature flag being true
        // should mean the matching special symbol is actually configured, or SymbolBag/
        // WinEvaluatorChain will silently no-op that feature for this machine.
        for machine in MachineCatalog.loadAll() {
            let f = machine.features
            if f.freeSpinsScatterValuator { XCTAssertNotNil(machine.freeSpins, "\(machine.machineName): freeSpinsScatterValuator true but no freeSpins symbol") }
            if f.bombScatterValuator { XCTAssertNotNil(machine.bomb, "\(machine.machineName): bombScatterValuator true but no bomb symbol") }
            if f.miniSpinScatterValuator { XCTAssertNotNil(machine.miniSpin, "\(machine.machineName): miniSpinScatterValuator true but no miniSpin symbol") }
            if f.bonusGameValuator { XCTAssertNotNil(machine.bonusGame, "\(machine.machineName): bonusGameValuator true but no bonusGame symbol") }
            if f.multiplierScatterValuator { XCTAssertNotNil(machine.multiplier, "\(machine.machineName): multiplierScatterValuator true but no multiplier symbol") }
        }
    }

    func testEveryMachine_withBonusGameValuator_hasAResolvableBonusGameKind() {
        for machine in MachineCatalog.loadAll() where machine.features.bonusGameValuator {
            guard let kind = machine.bonusGameKind else {
                XCTFail("\(machine.machineName): bonusGameValuator true but no bonusGameKind")
                continue
            }
            switch kind.family {
            case .higherLower:
                XCTAssertNil(kind.skin, "\(machine.machineName): higherLower shouldn't carry a skin")
            case .curtain:
                guard let skin = kind.skin else {
                    XCTFail("\(machine.machineName): curtain bonusGameKind with no skin name")
                    continue
                }
                XCTAssertNoThrow(try CurtainSkinCatalog.load(skin: skin), "\(machine.machineName): curtain skin '\(skin)' failed to load")
            }
        }
    }

    func testEveryMachine_symbolBagAndResultMatrixGeneratorProduceAValidSpin() {
        // End-to-end smoke test: build the real engine pipeline for every one of the 42
        // machines and confirm a spin resolves without crashing or producing garbage. This is
        // the single strongest check that the bulk-transcribed data is actually usable by the
        // engine, not just well-formed JSON.
        for machine in MachineCatalog.loadAll() {
            let bag = SymbolBag(
                normalSymbols: machine.normalSymbols, wild: machine.wild, factor: machine.factor,
                freeSpins: machine.freeSpins, bomb: machine.bomb, miniSpin: machine.miniSpin,
                bonusGame: machine.bonusGame, multiplier: machine.multiplier,
                ace: machine.ace, gold: machine.gold, king: machine.king
            )
            let paylines = Array(PaylineSet.all(for: machine.gridShape).prefix(machine.maxPaylines))
            let resolver = SpinResolver(machine: machine, bag: bag, paylines: paylines, diagonalWinLimitChips: 500)

            let result = resolver.resolve(selectedPaylines: paylines.count, selectedBetChips: 1.0)
            XCTAssertEqual(result.matrix.cells.count, machine.gridShape.cellCount, "\(machine.machineName): incomplete grid")
            XCTAssertGreaterThanOrEqual(result.payout.totalChips, 0, "\(machine.machineName): negative payout")
        }
    }

    func testAllFifteenCurtainSkins_loadAndProduceNonEmptyLevels() {
        let skins = ["holiday", "aircraft", "animals", "boat", "car", "christmas", "easter",
                     "funny", "halloween", "map", "newYear", "sports", "traffic", "weather", "zoo"]
        for skin in skins {
            guard let config = try? CurtainSkinCatalog.load(skin: skin) else {
                XCTFail("curtain skin '\(skin)' failed to load")
                continue
            }
            XCTAssertFalse(config.levels.isEmpty, "curtain skin '\(skin)' has no levels")
            for level in config.levels {
                XCTAssertGreaterThan(level.itemCount, 0, "\(skin) level \(level.id) has no items")
                XCTAssertLessThanOrEqual(level.selectiveItemsCount, level.itemCount, "\(skin) level \(level.id): selectiveItemsCount exceeds itemCount")
            }
        }
    }
}
