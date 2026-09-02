import XCTest
@testable import GotchaSlotsIOS

final class LobbyGatingTests: XCTestCase {
    func machine(openOnLevel: Int, isComingSoon: Bool) -> MachineConfiguration {
        let symbol = SymbolConfig(id: 0, assetName: "s", payoutTable: PayoutTable(payoutByHits: [5: 1]))
        return MachineConfiguration(
            id: 1, machineName: "Test", gridShape: .grid5x3, normalSymbols: [symbol], wild: symbol,
            factor: 1.0, maxPaylines: 1, openOnLevel: openOnLevel, isComingSoon: isComingSoon,
            depreciationRatio: 0.8,
            features: MachineFeatureFlags(
                strikeValuator: true, freeSpinsScatterValuator: false, bombScatterValuator: false,
                miniSpinScatterValuator: false, collectiblesScatterValuator: false, bonusGameValuator: false,
                columnValuator: false, symetricValuator: false, multiplierScatterValuator: false
            )
        )
    }

    func testLevelBelowRequirement_isLocked() {
        let m = machine(openOnLevel: 10, isComingSoon: false)
        XCTAssertFalse(m.isOpen(walletLevel: 5))
        XCTAssertEqual(m.lockedMessage(walletLevel: 5), "Need level 10")
    }

    func testLevelAtOrAboveRequirement_isOpen() {
        let m = machine(openOnLevel: 10, isComingSoon: false)
        XCTAssertTrue(m.isOpen(walletLevel: 10))
        XCTAssertTrue(m.isOpen(walletLevel: 20))
        XCTAssertEqual(m.lockedMessage(walletLevel: 10), "")
    }

    func testComingSoon_isLockedRegardlessOfLevel() {
        let m = machine(openOnLevel: 1, isComingSoon: true)
        XCTAssertFalse(m.isOpen(walletLevel: 999))
        XCTAssertEqual(m.lockedMessage(walletLevel: 999), "Coming Soon")
    }
}
