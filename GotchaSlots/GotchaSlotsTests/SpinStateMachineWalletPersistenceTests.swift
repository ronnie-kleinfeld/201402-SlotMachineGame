import XCTest
@testable import GotchaSlots

@MainActor
final class SpinStateMachineWalletPersistenceTests: XCTestCase {
    struct FakeResolver: SpinResolving {
        let result: SpinResult
        func resolve(selectedPaylines: Int, selectedBetChips: Double) -> SpinResult { result }
    }

    func makeResult(totalChips: Double) -> SpinResult {
        let matrix = ResultMatrix(cells: [:], gridShape: .grid5x3)
        let payout = SpinPayout(
            strikeResults: [], symetricResults: [], columnResults: [], bonusGameResults: [],
            freeSpinsResult: nil, bombResult: nil, miniSpinResult: nil, multiplierResult: nil,
            aceResult: nil, goldResult: nil, kingResult: nil,
            totalPayout: totalChips, totalChips: totalChips
        )
        return SpinResult(matrix: matrix, payout: payout)
    }

    func testNoWalletStore_balanceStaysPurelyInMemory() async {
        // Every pre-Phase-5 test relies on this: omitting walletStore must behave exactly as
        // before persistence existed.
        let resolver = FakeResolver(result: makeResult(totalChips: 0))
        let sm = SpinStateMachine(resolver: resolver, gridShape: .grid5x3, selectedPaylines: 20, selectedBetChips: 1.0, startingBalance: 500)
        XCTAssertEqual(sm.balance, 500)
        await sm.spin()
        XCTAssertEqual(sm.balance, 480) // just the bet deducted, no store to diverge from
    }

    func testWalletStore_seedsBalanceFromStoredState_ignoringStartingBalance() {
        let key = "com.gotchaslots.tests.\(UUID().uuidString)"
        defer { KeychainHelper.delete(key: key) }

        let store = KeychainStore<WalletState>(key: key)
        store.load()
        store.update { $0.balance = 777 }

        let resolver = FakeResolver(result: makeResult(totalChips: 0))
        let sm = SpinStateMachine(
            resolver: resolver, gridShape: .grid5x3, selectedPaylines: 20, selectedBetChips: 1.0,
            startingBalance: 1000, // must be ignored in favor of the store's 777
            walletStore: store
        )
        XCTAssertEqual(sm.balance, 777)
    }

    func testSpin_persistsBalanceChangesToTheStore() async {
        let key = "com.gotchaslots.tests.\(UUID().uuidString)"
        defer { KeychainHelper.delete(key: key) }

        let store = KeychainStore<WalletState>(key: key)
        store.load()

        let resolver = FakeResolver(result: makeResult(totalChips: 50))
        let sm = SpinStateMachine(
            resolver: resolver, gridShape: .grid5x3, selectedPaylines: 20, selectedBetChips: 1.0,
            startingBalance: 1000, walletStore: store
        )
        await sm.spin()
        // 1000 - 20 (bet) + 50 (win) = 1030, and the store itself should now reflect that.
        XCTAssertEqual(sm.balance, 1030)
        XCTAssertEqual(store.state.balance, 1030)

        // A fresh store reading the same key sees the persisted value.
        let reloaded = KeychainStore<WalletState>(key: key)
        reloaded.load()
        XCTAssertEqual(reloaded.state.balance, 1030)
    }
}
