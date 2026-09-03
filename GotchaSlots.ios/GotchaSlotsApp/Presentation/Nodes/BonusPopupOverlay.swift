import SpriteKit

/// A modal "collect your bonus" popup — shared visual shape for the welcome bonus and daily
/// bonus (both are structurally identical: a message, a chip amount, a single Collect button),
/// ports WelcomePopup/DailyBonusPopup's role without replicating their bespoke art/animation.
final class BonusPopupOverlay: SKNode {
    var onCollect: (() -> Void)?

    private let sceneSize: CGSize

    init(sceneSize: CGSize, title: String, message: String, amountChips: Double) {
        self.sceneSize = sceneSize
        super.init()
        zPosition = 1000
        build(title: title, message: message, amountChips: amountChips)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func build(title: String, message: String, amountChips: Double) {
        let dimmer = SKShapeNode(rectOf: sceneSize)
        dimmer.fillColor = SKColor(white: 0, alpha: 0.75)
        dimmer.strokeColor = .clear
        dimmer.position = CGPoint(x: sceneSize.width / 2, y: sceneSize.height / 2)
        dimmer.name = "bonusPopupDimmer"
        addChild(dimmer)

        let panelSize = CGSize(width: 600, height: 460)
        let panel = SKShapeNode(rectOf: panelSize, cornerRadius: 20)
        panel.fillColor = SKColor(red: 0.1, green: 0.11, blue: 0.16, alpha: 1)
        panel.strokeColor = .white
        panel.lineWidth = 2
        panel.position = CGPoint(x: sceneSize.width / 2, y: sceneSize.height / 2)
        addChild(panel)

        let titleLabel = SKLabelNode(text: title)
        titleLabel.fontName = "HelveticaNeue-Bold"
        titleLabel.fontSize = 32
        titleLabel.fontColor = .white
        titleLabel.position = CGPoint(x: 0, y: 150)
        panel.addChild(titleLabel)

        let messageLabel = SKLabelNode(text: message)
        messageLabel.fontName = "HelveticaNeue"
        messageLabel.fontSize = 18
        messageLabel.fontColor = SKColor(white: 0.85, alpha: 1)
        messageLabel.position = CGPoint(x: 0, y: 90)
        panel.addChild(messageLabel)

        let amountLabel = SKLabelNode(text: "+\(Int(amountChips)) chips")
        amountLabel.fontName = "HelveticaNeue-Bold"
        amountLabel.fontSize = 48
        amountLabel.fontColor = .systemYellow
        amountLabel.position = CGPoint(x: 0, y: 0)
        panel.addChild(amountLabel)

        let button = SKShapeNode(rectOf: CGSize(width: 280, height: 70), cornerRadius: 14)
        button.fillColor = SKColor.systemGreen.withAlphaComponent(0.9)
        button.strokeColor = .white
        button.lineWidth = 1.5
        button.position = CGPoint(x: 0, y: -140)
        button.name = "bonusPopupCollect"
        panel.addChild(button)

        let buttonLabel = SKLabelNode(text: "Collect")
        buttonLabel.fontName = "HelveticaNeue-Bold"
        buttonLabel.fontSize = 26
        buttonLabel.fontColor = .white
        buttonLabel.verticalAlignmentMode = .center
        buttonLabel.name = "bonusPopupCollect"
        button.addChild(buttonLabel)
    }

    /// Called by the owning scene's touch handling with the tapped node's name.
    func handleTap(nodeName: String) -> Bool {
        if nodeName == "bonusPopupCollect" {
            onCollect?()
            return true
        }
        if nodeName == "bonusPopupDimmer" {
            return true // swallow taps on the dimmer — collect via the button, not dismiss-by-tap
        }
        return false
    }
}
