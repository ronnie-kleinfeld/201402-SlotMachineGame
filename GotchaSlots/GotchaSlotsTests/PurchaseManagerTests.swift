import XCTest
import StoreKitTest
@testable import GotchaSlots

/// Uses StoreKitTest's `SKTestSession` to drive real StoreKit2 purchase flows locally against
/// `GotchaSlots.storekit` — no App Store Connect account or network access required. This is
/// what makes the IAP layer actually verifiable in this environment, unlike social/ads which
/// need real third-party credentials this session doesn't have.
@MainActor
final class PurchaseManagerTests: XCTestCase {
    var session: SKTestSession!

    override func setUpWithError() throws {
        // Resolve GotchaSlots.storekit by file path (not bundle lookup) so this doesn't depend
        // on how the test target happens to copy resources.
        let storeKitURL = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent() // GotchaSlotsTests/
            .deletingLastPathComponent() // GotchaSlots/ (contains GotchaSlots.storekit)
            .appendingPathComponent("GotchaSlots.storekit")
        session = try SKTestSession(contentsOf: storeKitURL)
        session.disableDialogs = true
        session.clearTransactions()
        session.resetToDefaultState()
    }

    override func tearDownWithError() throws {
        session.clearTransactions()
        session = nil
    }

    /// `SKTestSession` occasionally isn't fully ready the instant it's created, so the very
    /// first `Product.products(for:)` call in a test can race it and come back empty — retry a
    /// few times with a short delay rather than flaking.
    private func loadProductsWithRetry(_ manager: PurchaseManager, attempts: Int = 5) async {
        for attempt in 1...attempts {
            await manager.loadProducts()
            if !manager.products.isEmpty { return }
            try? await Task.sleep(nanoseconds: UInt64(attempt) * 300_000_000)
        }
    }

    private func makeManager() -> (PurchaseManager, KeychainStore<WalletState>, String) {
        let key = "com.gotchaslots.tests.\(UUID().uuidString)"
        let store = KeychainStore<WalletState>(key: key)
        store.load()
        return (PurchaseManager(walletStore: store), store, key)
    }

    func testLoadProducts_returnsAllFourConfiguredTiers() async {
        let (manager, _, key) = makeManager()
        defer { KeychainHelper.delete(key: key) }

        await loadProductsWithRetry(manager)
        XCTAssertEqual(Set(manager.products.map(\.id)), Set(ChipProduct.all.map(\.id)))
    }

    func testPurchase_grantsTheCorrectChipsAndPersistsThem() async {
        let (manager, store, key) = makeManager()
        defer { KeychainHelper.delete(key: key) }
        let startingBalance = store.state.balance

        await loadProductsWithRetry(manager)
        guard let product = manager.products.first(where: { $0.id == "com.gotchaslots.ios.chips.099" }) else {
            XCTFail("099 product not found among loaded products")
            return
        }

        await manager.purchase(product)

        guard case .success(let chipsGranted) = manager.purchaseState else {
            XCTFail("expected .success, got \(manager.purchaseState)")
            return
        }
        XCTAssertEqual(chipsGranted, 15_000)
        XCTAssertEqual(store.state.balance, startingBalance + 15_000)
    }

    func testPurchase_ofHighestTier_grantsTheRightAmount() async {
        let (manager, store, key) = makeManager()
        defer { KeychainHelper.delete(key: key) }
        let startingBalance = store.state.balance

        await loadProductsWithRetry(manager)
        guard let product = manager.products.first(where: { $0.id == "com.gotchaslots.ios.chips.999" }) else {
            XCTFail("999 product not found among loaded products")
            return
        }

        await manager.purchase(product)

        guard case .success(let chipsGranted) = manager.purchaseState else {
            XCTFail("expected .success, got \(manager.purchaseState)")
            return
        }
        XCTAssertEqual(chipsGranted, 190_000)
        XCTAssertEqual(store.state.balance, startingBalance + 190_000)
    }
}
