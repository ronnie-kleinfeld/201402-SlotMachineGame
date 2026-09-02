import StoreKit

enum PurchaseError: Error {
    case unverified
    case unknownProduct
    case userCancelled
    case pending
}

/// Ports BaseInAppPurchaseHandler/AppStoreInAppPurchaseHandler's role using StoreKit2 instead
/// of the original's Milkman StoreKit ANE wrapper. Two deliberate improvements over the
/// original, not a like-for-like port:
///   1. Receipt validation: the AS3 handler trusted `PURCHASE_SUCCEEDED` client-side with no
///      verification at all. StoreKit2's `VerificationResult` performs cryptographic signature
///      verification automatically (`checkVerified` below) — chips are only granted after that
///      passes, closer to (though still not equivalent to) server-side validation.
///   2. Interrupted transactions: `Transaction.updates` (listened to for the object's whole
///      lifetime) picks up purchases that succeeded after the app was killed mid-purchase, a
///      class of bug the original's synchronous ANE callback pattern couldn't handle.
@MainActor
final class PurchaseManager: ObservableObject {
    enum PurchaseState: Equatable {
        case idle
        case purchasing
        case success(chipsGranted: Int)
        case failed(String)
    }

    @Published private(set) var products: [Product] = []
    @Published private(set) var purchaseState: PurchaseState = .idle

    private let walletStore: KeychainStore<WalletState>
    private var transactionListener: Task<Void, Never>?

    init(walletStore: KeychainStore<WalletState>) {
        self.walletStore = walletStore
        transactionListener = Task { [weak self] in
            for await update in Transaction.updates {
                await self?.handle(update)
            }
        }
    }

    deinit {
        transactionListener?.cancel()
    }

    func loadProducts() async {
        do {
            products = try await Product.products(for: ChipProduct.all.map(\.id))
        } catch {
            purchaseState = .failed("Couldn't load products: \(error.localizedDescription)")
        }
    }

    /// Ports BaseInAppPurchaseHandler.Purchase(productID): request the purchase, verify the
    /// result, grant chips, and finish the transaction (required by StoreKit2 to remove it from
    /// the unfinished-transaction queue).
    func purchase(_ product: Product) async {
        purchaseState = .purchasing
        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                let transaction = try checkVerified(verification)
                await grantChips(for: transaction)
                await transaction.finish()
            case .userCancelled:
                purchaseState = .idle
            case .pending:
                purchaseState = .failed("Purchase pending (e.g. Ask to Buy) — not yet completed.")
            @unknown default:
                purchaseState = .idle
            }
        } catch {
            purchaseState = .failed(error.localizedDescription)
        }
    }

    private func handle(_ update: VerificationResult<Transaction>) async {
        guard let transaction = try? checkVerified(update) else { return }
        await grantChips(for: transaction)
        await transaction.finish()
    }

    private func grantChips(for transaction: Transaction) async {
        guard let chips = ChipProduct.chips(forProductID: transaction.productID) else {
            purchaseState = .failed("Unknown product ID: \(transaction.productID)")
            return
        }
        walletStore.update { $0.balance += Double(chips) }
        purchaseState = .success(chipsGranted: chips)
    }

    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw PurchaseError.unverified
        case .verified(let value):
            return value
        }
    }
}
