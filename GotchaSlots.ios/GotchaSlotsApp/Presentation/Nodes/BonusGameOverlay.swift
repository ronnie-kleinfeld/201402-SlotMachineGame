import SpriteKit

/// A modal-style overlay presenting whichever bonus-game family SpinStateMachine has started
/// (`activeBonusGame`) — this is what makes the already-built, already-tested CurtainGameState/
/// HigherLowerGameState engines actually reachable from the app, not just exercised in isolation
/// by CurtainGameTests/HigherLowerGameTests/SpinStateMachineBonusGameTests.
///
/// SpinStateMachine settles the bonus game (adds its chips, clears `activeBonusGame`) the instant
/// `pick`/`guess` reports the game over, so there's no "final revealed state" to read back after
/// the fact — this overlay infers the payout from the balance delta across the call instead and
/// hands it to `onDismiss`, rather than showing a per-item reveal of the terminal pick.
final class BonusGameOverlay: SKNode {
    private let stateMachine: SpinStateMachine
    /// Passes the chips the bonus game paid out (inferred from the balance delta), so the caller
    /// can surface it the same way a spin's own win is surfaced.
    var onDismiss: ((Double) -> Void)?

    private let sceneSize: CGSize
    private let panel: SKShapeNode
    private var isBusy = false
    private var balanceAtOpen: Double

    init(sceneSize: CGSize, stateMachine: SpinStateMachine) {
        self.sceneSize = sceneSize
        self.stateMachine = stateMachine
        self.balanceAtOpen = stateMachine.balance

        let panelSize = CGSize(width: 640, height: 760)
        panel = SKShapeNode(rectOf: panelSize, cornerRadius: 20)
        panel.fillColor = SKColor(red: 0.1, green: 0.11, blue: 0.16, alpha: 1)
        panel.strokeColor = .white
        panel.lineWidth = 2
        panel.position = CGPoint(x: sceneSize.width / 2, y: sceneSize.height / 2)

        super.init()
        zPosition = 1000

        let dimmer = SKShapeNode(rectOf: sceneSize)
        dimmer.fillColor = SKColor(white: 0, alpha: 0.75)
        dimmer.strokeColor = .clear
        dimmer.position = CGPoint(x: sceneSize.width / 2, y: sceneSize.height / 2)
        dimmer.name = "bonusGameDimmer"
        addChild(dimmer)
        addChild(panel)

        refresh()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    /// Rebuilds the panel contents from `stateMachine.activeBonusGame`'s current state. Called
    /// after every pick/guess (state changed) and once at init. Simplest correct approach for a
    /// small, infrequently-updated node tree — no incremental diffing.
    private func refresh() {
        panel.removeAllChildren()

        guard let activeBonusGame = stateMachine.activeBonusGame else {
            let chipsWon = stateMachine.balance - balanceAtOpen
            onDismiss?(chipsWon)
            return
        }

        switch activeBonusGame {
        case .curtain(let state):
            buildCurtain(state)
        case .higherLower(let state):
            buildHigherLower(state)
        }
    }

    // MARK: - Curtain (pick-a-box)

    private func buildCurtain(_ state: CurtainGameState) {
        guard let level = state.currentLevel else { return }

        addTitle("Bonus Game")
        addMessage(level.tickerMessage.isEmpty ? level.mapMessage : level.tickerMessage, y: 300)

        let columns = 4
        let boxSize = CGSize(width: 120, height: 90)
        let spacing: CGFloat = 16
        let gridWidth = CGFloat(columns) * boxSize.width + CGFloat(columns - 1) * spacing
        let originX = -gridWidth / 2 + boxSize.width / 2
        let startY: CGFloat = 200

        for (index, item) in level.items.enumerated() {
            let row = index / columns
            let column = index % columns
            let box = SKShapeNode(rectOf: boxSize, cornerRadius: 12)
            box.position = CGPoint(
                x: originX + CGFloat(column) * (boxSize.width + spacing),
                y: startY - CGFloat(row) * (boxSize.height + spacing)
            )

            let label = SKLabelNode(fontNamed: "HelveticaNeue-Bold")
            label.fontSize = 26
            label.verticalAlignmentMode = .center
            label.position = .zero

            if item.isSelected {
                box.fillColor = item.isFailure
                    ? SKColor.systemRed.withAlphaComponent(0.6)
                    : SKColor.systemGreen.withAlphaComponent(0.6)
                box.strokeColor = .white
                label.text = item.isFailure ? "\u{2620}" : "+\(item.payout)"
                label.fontColor = .white
            } else {
                box.fillColor = SKColor(white: 1, alpha: 0.12)
                box.strokeColor = .white
                box.name = "bonusItem_\(item.id)"
                label.text = "?"
                label.fontColor = SKColor(white: 0.8, alpha: 1)
                label.name = box.name
            }
            box.addChild(label)
            panel.addChild(box)
        }
    }

    // MARK: - Higher/Lower ladder

    private func buildHigherLower(_ state: HigherLowerGameState) {
        addTitle("Higher or Lower?")

        let rung = state.currentRung
        addMessage("Current ratio: \(formatted(rung.ratio))x", y: 260)

        let numberLabel = SKLabelNode(text: "\(rung.random)")
        numberLabel.fontName = "HelveticaNeue-Bold"
        numberLabel.fontSize = 72
        numberLabel.fontColor = .white
        numberLabel.position = CGPoint(x: 0, y: 100)
        panel.addChild(numberLabel)

        let ladderText = state.rungs.map { r in
            r.id == state.currentIndex ? "[\(formatted(r.ratio))x]" : "\(formatted(r.ratio))x"
        }.joined(separator: "  ")
        addMessage(ladderText, y: 20, fontSize: 16)

        let lowerButton = makeChoiceButton(text: "Lower", name: "bonusGuessLower", x: -140, y: -140, color: .systemRed)
        let higherButton = makeChoiceButton(text: "Higher", name: "bonusGuessHigher", x: 140, y: -140, color: .systemGreen)
        panel.addChild(lowerButton)
        panel.addChild(higherButton)
    }

    private func makeChoiceButton(text: String, name: String, x: CGFloat, y: CGFloat, color: SKColor) -> SKShapeNode {
        let button = SKShapeNode(rectOf: CGSize(width: 220, height: 70), cornerRadius: 14)
        button.fillColor = color.withAlphaComponent(0.85)
        button.strokeColor = .white
        button.lineWidth = 1.5
        button.position = CGPoint(x: x, y: y)
        button.name = name

        let label = SKLabelNode(text: text)
        label.fontName = "HelveticaNeue-Bold"
        label.fontSize = 24
        label.fontColor = .white
        label.verticalAlignmentMode = .center
        label.name = name
        button.addChild(label)
        return button
    }

    // MARK: - Shared helpers

    private func addTitle(_ text: String) {
        let title = SKLabelNode(text: text)
        title.fontName = "HelveticaNeue-Bold"
        title.fontSize = 32
        title.fontColor = .white
        title.position = CGPoint(x: 0, y: 330)
        panel.addChild(title)
    }

    private func addMessage(_ text: String, y: CGFloat, fontSize: CGFloat = 18) {
        let label = SKLabelNode(text: text)
        label.fontName = "HelveticaNeue"
        label.fontSize = fontSize
        label.fontColor = SKColor(white: 0.85, alpha: 1)
        label.position = CGPoint(x: 0, y: y)
        panel.addChild(label)
    }

    private func formatted(_ ratio: Double) -> String {
        ratio == ratio.rounded() ? String(Int(ratio)) : String(ratio)
    }

    /// Called by MachineScene's touchesBegan with the tapped node's name.
    func handleTap(nodeName: String) -> Bool {
        guard !isBusy else { return true }

        if nodeName.hasPrefix("bonusItem_"), let itemID = Int(nodeName.dropFirst("bonusItem_".count)) {
            isBusy = true
            stateMachine.pickCurtainItem(itemID)
            isBusy = false
            refresh()
            return true
        }
        if nodeName == "bonusGuessHigher" || nodeName == "bonusGuessLower" {
            isBusy = true
            stateMachine.guessHigherLower(nodeName == "bonusGuessHigher" ? .higher : .lower)
            isBusy = false
            refresh()
            return true
        }
        if nodeName == "bonusGameDimmer" {
            return true // swallow taps on the dimmer — no manual dismiss while a bonus game is active
        }
        return false
    }
}
