import XCTest
@testable import GotchaSlotsIOS

final class KeychainStoreTests: XCTestCase {
    // Unique key per test so parallel/repeated runs don't collide on leftover Keychain state.
    func uniqueKey() -> String { "com.gotchaslots.tests.\(UUID().uuidString)" }

    func testFreshKey_loadsDefaultValue_andPersistsIt() {
        let key = uniqueKey()
        defer { KeychainHelper.delete(key: key) }

        let store = KeychainStore<WalletState>(key: key)
        store.load()
        XCTAssertEqual(store.state.balance, WalletState.defaultValue.balance)
        XCTAssertEqual(store.state.level, WalletState.defaultValue.level)

        // The default should have been written back (ports `Init(); Save();`), so a second
        // store instance reading the same key sees it without needing another default-write.
        let reloaded = KeychainStore<WalletState>(key: key)
        reloaded.load()
        XCTAssertEqual(reloaded.state.balance, WalletState.defaultValue.balance)
    }

    func testUpdate_persistsAcrossInstances() {
        let key = uniqueKey()
        defer { KeychainHelper.delete(key: key) }

        let store = KeychainStore<WalletState>(key: key)
        store.load()
        store.update { $0.balance = 12345; $0.level = 7 }

        let reloaded = KeychainStore<WalletState>(key: key)
        reloaded.load()
        XCTAssertEqual(reloaded.state.balance, 12345)
        XCTAssertEqual(reloaded.state.level, 7)
    }

    func testSaveBeforeLoad_isANoOp() {
        // Ports the `_initialized` guard: calling save() before load() must not write anything,
        // since the in-memory state is still just the type's default, not necessarily what
        // should be persisted.
        let key = uniqueKey()
        defer { KeychainHelper.delete(key: key) }

        let store = KeychainStore<WalletState>(key: key)
        store.save() // no load() first
        XCTAssertNil(KeychainHelper.read(key: key))
    }
}
