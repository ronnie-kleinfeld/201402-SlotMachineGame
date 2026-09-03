import SpriteKit
import StoreKit

/// A modal-style overlay listing the 4 chip packages (ChipProduct.all / GotchaSlots.storekit),
/// wired to the already-built PurchaseManager — this is what makes IAP actually reachable from
/// the app, not just exercised in isolation by PurchaseManagerTests.
final class BuyChipsOverlay: SKNode {
    private let purchaseManager: PurchaseManager
    var onDismiss: (() -> Void)?
    var onPurchaseSucceeded: (() -> Void)?

    private let sceneSize: CGSize
    private var statusLabel: SKLabelNode!
    private var tileButtons: [SKShapeNode] = []
    private var isPurchasing = false

    init(sceneSize: CGSize, purchaseManager: PurchaseManager) {
        self.sceneSize = sceneSize
        self.purchaseManager = purchaseManager
        super.init()
        zPosition = 1000
        build()
        loadProducts()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func build() {
        let dimmer = SKShapeNode(rectOf: sceneSize)
        dimmer.fillColor = SKColor(white: 0, alpha: 0.7)
        dimmer.strokeColor = .clear
        dimmer.position = CGPoint(x: sceneSize.width / 2, y: sceneSize.height / 2)
        dimmer.name = "buyChipsDimmer"
        addChild(dimmer)

        let panelSize = CGSize(width: 620, height: 700)
        let panel = SKShapeNode(rectOf: panelSize, cornerRadius: 20)
        panel.fillColor = SKColor(red: 0.1, green: 0.11, blue: 0.16, alpha: 1)
        panel.strokeColor = .white
        panel.lineWidth = 2
        panel.position = CGPoint(x: sceneSize.width / 2, y: sceneSize.height / 2)
        addChild(panel)

        let title = SKLabelNode(text: "Buy Chips")
        title.fontName = "HelveticaNeue-Bold"
        title.fontSize = 32
        title.fontColor = .white
        title.position = CGPoint(x: 0, y: panelSize.height / 2 - 60)
        panel.addChild(title)

        statusLabel = SKLabelNode(text: "Loading products…")
        statusLabel.fontName = "HelveticaNeue"
        statusLabel.fontSize = 18
        statusLabel.fontColor = SKColor(white: 0.8, alpha: 1)
        statusLabel.position = CGPoint(x: 0, y: panelSize.height / 2 - 100)
        panel.addChild(statusLabel)

        let closeButton = SKShapeNode(circleOfRadius: 22)
        closeButton.fillColor = SKColor(white: 1, alpha: 0.15)
        closeButton.strokeColor = .white
        closeButton.lineWidth = 1.5
        closeButton.position = CGPoint(x: panelSize.width / 2 - 40, y: panelSize.height / 2 - 40)
        closeButton.name = "buyChipsClose"
        panel.addChild(closeButton)
        let closeLabel = SKLabelNode(text: "✕")
        closeLabel.fontName = "HelveticaNeue-Bold"
        closeLabel.fontSize = 20
        closeLabel.fontColor = .white
        closeLabel.verticalAlignmentMode = .center
        closeLabel.name = "buyChipsClose"
        closeButton.addChild(closeLabel)

        let tileSize = CGSize(width: 540, height: 110)
        let spacing: CGFloat = 20
        let startY = panelSize.height / 2 - 180

        for (index, product) in ChipProduct.all.enumerated() {
            let tile = SKShapeNode(rectOf: tileSize, cornerRadius: 14)
            tile.fillColor = SKColor(red: 0.14, green: 0.4, blue: 0.24, alpha: 1)
            tile.strokeColor = .white
            tile.lineWidth = 1.5
            tile.position = CGPoint(x: 0, y: startY - CGFloat(index) * (tileSize.height + spacing))
            tile.name = "buyChipsTile_\(product.id)"
            panel.addChild(tile)
            tileButtons.append(tile)

            let chipsLabel = SKLabelNode(text: "\(product.chips) chips")
            chipsLabel.fontName = "HelveticaNeue-Bold"
            chipsLabel.fontSize = 24
            chipsLabel.fontColor = .white
            chipsLabel.position = CGPoint(x: -tileSize.width / 2 + 24, y: -8)
            chipsLabel.horizontalAlignmentMode = .left
            chipsLabel.name = tile.name
            tile.addChild(chipsLabel)

            let priceLabel = SKLabelNode(text: "…")
            priceLabel.fontName = "HelveticaNeue-Bold"
            priceLabel.fontSize = 26
            priceLabel.fontColor = SKColor.systemYellow
            priceLabel.position = CGPoint(x: tileSize.width / 2 - 24, y: -8)
            priceLabel.horizontalAlignmentMode = .right
            priceLabel.name = "buyChipsPrice_\(product.id)"
            tile.addChild(priceLabel)
        }
    }

    private func loadProducts() {
        Task { @MainActor in
            await purchaseManager.loadProducts()
            for skProduct in purchaseManager.products {
                if let priceLabel = childNode(withName: "//buyChipsPrice_\(skProduct.id)") as? SKLabelNode {
                    priceLabel.text = skProduct.displayPrice
                }
            }
            if purchaseManager.products.isEmpty {
                statusLabel.text = "Couldn't load products"
            } else {
                statusLabel.text = ""
            }
        }
    }

    /// Called by MachineScene's touchesBegan with the tapped node's name.
    func handleTap(nodeName: String) -> Bool {
        if nodeName == "buyChipsClose" {
            onDismiss?()
            return true
        }
        if nodeName.hasPrefix("buyChipsTile_") {
            let productID = String(nodeName.dropFirst("buyChipsTile_".count))
            purchaseTapped(productID: productID)
            return true
        }
        if nodeName == "buyChipsDimmer" {
            return true // swallow taps on the dimmer without dismissing (avoid accidental close)
        }
        return false
    }

    private func purchaseTapped(productID: String) {
        guard !isPurchasing, let skProduct = purchaseManager.products.first(where: { $0.id == productID }) else { return }
        isPurchasing = true
        statusLabel.text = "Purchasing…"

        Task { @MainActor in
            await purchaseManager.purchase(skProduct)
            switch purchaseManager.purchaseState {
            case .success(let chipsGranted):
                statusLabel.text = "+\(chipsGranted) chips!"
                onPurchaseSucceeded?()
            case .failed(let message):
                statusLabel.text = message
            case .idle, .purchasing:
                statusLabel.text = ""
            }
            isPurchasing = false
        }
    }
}
