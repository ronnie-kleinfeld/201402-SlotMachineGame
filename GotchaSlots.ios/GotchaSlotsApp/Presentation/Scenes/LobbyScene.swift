import SpriteKit

/// Ports CommonLobbyMachineData's level-gating rule (IsOpen/LockedMessage), simplified to drop
/// the invite-unlock exception (`MachineSession.IsInvite4Unlocked`) — a social/invite feature
/// out of scope for this port: `!isComingSoon && walletLevel >= openOnLevel`.
extension MachineConfiguration {
    func isOpen(walletLevel: Int) -> Bool {
        !isComingSoon && walletLevel >= openOnLevel
    }

    func lockedMessage(walletLevel: Int) -> String {
        if isOpen(walletLevel: walletLevel) { return "" }
        if isComingSoon { return "Coming Soon" }
        return "Need level \(openOnLevel)"
    }
}

/// Ports the lobby machine-select grid (com/gotchaslots/slots/ui/lobby): one tile per machine
/// in the catalog (42 since Phase 7), locked tiles showing why (level requirement or "coming
/// soon"), unlocked tiles launching MachineScene on tap. Tiles live in a scrollable container —
/// with the full 42-machine catalog they don't come close to fitting one screen.
final class LobbyScene: SKScene {
    private let machines: [MachineConfiguration]
    private let walletLevel: Int
    private let walletStore: KeychainStore<WalletState>?
    private let bonusStore: KeychainStore<BonusState>?
    var onSelectMachine: ((MachineConfiguration) -> Void)?

    private static let sceneSize = CGSize(width: 750, height: 1334)
    private static let visibleBottomMargin: CGFloat = 40

    private let contentNode = SKNode()
    /// Upper bound for `contentNode.position.y` (tiles are laid out top-down at decreasing
    /// local Y, so revealing later tiles means moving the container's Y *up*, i.e. more
    /// positive — not the negative-scroll direction a top-down list might suggest). 0 when
    /// every tile already fits without scrolling.
    private var maxContentY: CGFloat = 0
    private var dragStartTouchY: CGFloat?
    private var contentYAtDragStart: CGFloat = 0
    private var didDragPastTapThreshold = false

    private var timerBonusButton: SKShapeNode!
    private var timerBonusLabel: SKLabelNode!
    private var bonusPopup: BonusPopupOverlay?

    init(
        machines: [MachineConfiguration], walletLevel: Int,
        walletStore: KeychainStore<WalletState>? = nil, bonusStore: KeychainStore<BonusState>? = nil
    ) {
        self.machines = machines
        self.walletLevel = walletLevel
        self.walletStore = walletStore
        self.bonusStore = bonusStore
        super.init(size: Self.sceneSize)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func didMove(to view: SKView) {
        backgroundColor = SKColor(red: 0.06, green: 0.07, blue: 0.12, alpha: 1)

        let title = SKLabelNode(text: "GotchaSlots")
        title.fontName = "HelveticaNeue-Bold"
        title.fontSize = 40
        title.fontColor = .white
        title.position = CGPoint(x: size.width / 2, y: size.height * 0.95)
        title.zPosition = 500
        addChild(title)

        buildTimerBonusButton()
        addChild(contentNode)
        buildMachineTiles()
        showNextEligibleBonusPopup()
    }

    private func buildTimerBonusButton() {
        timerBonusButton = SKShapeNode(rectOf: CGSize(width: 200, height: 50), cornerRadius: 12)
        timerBonusButton.strokeColor = .white
        timerBonusButton.lineWidth = 1.5
        timerBonusButton.position = CGPoint(x: size.width - 130, y: size.height * 0.88)
        timerBonusButton.name = "timerBonusButton"
        timerBonusButton.zPosition = 500
        addChild(timerBonusButton)

        timerBonusLabel = SKLabelNode(fontNamed: "HelveticaNeue-Bold")
        timerBonusLabel.fontSize = 16
        timerBonusLabel.fontColor = .white
        timerBonusLabel.verticalAlignmentMode = .center
        timerBonusLabel.name = "timerBonusButton"
        timerBonusButton.addChild(timerBonusLabel)

        refreshTimerBonusButton()
    }

    private func refreshTimerBonusButton() {
        guard let bonusStore else {
            timerBonusButton.isHidden = true
            return
        }
        let isReady = BonusEligibility.isTimerBonusReady(bonusStore.state)
        timerBonusButton.fillColor = isReady
            ? SKColor.systemYellow.withAlphaComponent(0.9)
            : SKColor(white: 1, alpha: 0.1)
        if isReady {
            timerBonusLabel.text = "Timer Bonus!"
        } else {
            let remaining = Int(BonusEligibility.timerBonusTimeRemaining(bonusStore.state))
            timerBonusLabel.text = "Timer \(remaining / 3600)h \((remaining % 3600) / 60)m"
        }
    }

    /// Ports LobbyPanel.OnAddedToStage's sequential popup chain (welcome, then daily bonus) —
    /// simplified to skip the invite/Facebook-connect steps, which need social infrastructure
    /// out of scope for this port.
    private func showNextEligibleBonusPopup() {
        guard bonusPopup == nil, let bonusStore, let walletStore else { return }

        if !bonusStore.state.isWelcomeBonusCollected {
            let amount = LevelThresholds.welcomeBonusChips(forLevel: walletLevel)
            presentBonusPopup(
                title: "Welcome!", message: "Thanks for playing GotchaSlots", amount: amount
            ) { [weak self] in
                guard let self else { return }
                var awarded = 0.0
                bonusStore.update { awarded = BonusEligibility.collectWelcomeBonus(&$0, level: self.walletLevel) }
                walletStore.update { $0.balance += awarded }
            }
        } else if BonusEligibility.isDailyBonusReady(bonusStore.state) {
            let dayIndex = BonusEligibility.nextDailyBonusDayIndex(bonusStore.state)
            let amount = LevelThresholds.levelReachedBonusChips(forLevel: walletLevel) * Double(dayIndex)
            presentBonusPopup(
                title: "Daily Bonus", message: "Day \(dayIndex) login bonus", amount: amount
            ) { [weak self] in
                guard let self else { return }
                var awarded = 0.0
                bonusStore.update { awarded = BonusEligibility.collectDailyBonus(&$0, level: self.walletLevel) }
                walletStore.update { $0.balance += awarded }
            }
        }
    }

    private func presentBonusPopup(title: String, message: String, amount: Double, onCollect: @escaping () -> Void) {
        let overlay = BonusPopupOverlay(sceneSize: size, title: title, message: message, amountChips: amount)
        overlay.onCollect = { [weak self] in
            onCollect()
            self?.dismissBonusPopup()
        }
        addChild(overlay)
        bonusPopup = overlay
    }

    private func dismissBonusPopup() {
        bonusPopup?.removeFromParent()
        bonusPopup = nil
        // The welcome bonus and daily bonus are shown sequentially — check whether the next one
        // in the chain is now eligible.
        showNextEligibleBonusPopup()
    }

    private func buildMachineTiles() {
        let tileSize = CGSize(width: 660, height: 190)
        let spacing: CGFloat = 24
        let step = tileSize.height + spacing
        let startY = size.height * 0.86

        for (index, machine) in machines.enumerated() {
            let isOpen = machine.isOpen(walletLevel: walletLevel)

            let tile = SKShapeNode(rectOf: tileSize, cornerRadius: 16)
            tile.fillColor = isOpen ? SKColor(red: 0.14, green: 0.4, blue: 0.24, alpha: 1) : SKColor(white: 0.15, alpha: 1)
            tile.strokeColor = .white
            tile.lineWidth = 2
            tile.alpha = isOpen ? 1.0 : 0.6
            tile.position = CGPoint(x: size.width / 2, y: startY - CGFloat(index) * step)
            tile.name = "machine_\(machine.id)"
            contentNode.addChild(tile)

            let thumbnailBoxWidth = tileSize.height - 24
            var textStartX = -tileSize.width / 2 + 24
            if let image = UIImage(named: "\(machine.machineName)_Thumbnail") {
                let thumbSize = CGSize(width: thumbnailBoxWidth, height: thumbnailBoxWidth)
                let texture = SKTexture(image: image)
                let scale = min(thumbSize.width / texture.size().width, thumbSize.height / texture.size().height)
                let thumbnail = SKSpriteNode(texture: texture)
                thumbnail.size = CGSize(width: texture.size().width * scale, height: texture.size().height * scale)
                thumbnail.position = CGPoint(x: -tileSize.width / 2 + tileSize.height / 2, y: 0)
                thumbnail.alpha = isOpen ? 1.0 : 0.5
                thumbnail.name = tile.name
                tile.addChild(thumbnail)
                textStartX = -tileSize.width / 2 + tileSize.height + 16
            }

            let nameLabel = SKLabelNode(text: machine.machineName)
            nameLabel.fontName = "HelveticaNeue-Bold"
            nameLabel.fontSize = 28
            nameLabel.fontColor = .white
            nameLabel.horizontalAlignmentMode = .left
            nameLabel.position = CGPoint(x: textStartX, y: 15)
            nameLabel.name = tile.name
            tile.addChild(nameLabel)

            let statusText = isOpen
                ? "Grid \(machine.gridShape.rows)x\(machine.gridShape.columns) · \(machine.maxPaylines) lines"
                : machine.lockedMessage(walletLevel: walletLevel)
            let statusLabel = SKLabelNode(text: statusText)
            statusLabel.fontName = "HelveticaNeue"
            statusLabel.fontSize = 18
            statusLabel.fontColor = SKColor(white: 0.9, alpha: 1)
            statusLabel.horizontalAlignmentMode = .left
            statusLabel.position = CGPoint(x: textStartX, y: -22)
            statusLabel.name = tile.name
            tile.addChild(statusLabel)
        }

        let lastTileBottomLocalY = startY - CGFloat(max(machines.count - 1, 0)) * step - tileSize.height / 2
        maxContentY = max(0, Self.visibleBottomMargin - lastTileBottomLocalY)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        if let bonusPopup {
            let name = atPoint(touch.location(in: self)).name ?? ""
            _ = bonusPopup.handleTap(nodeName: name)
            return
        }
        dragStartTouchY = touch.location(in: self).y
        contentYAtDragStart = contentNode.position.y
        didDragPastTapThreshold = false
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard bonusPopup == nil else { return }
        guard let touch = touches.first, let dragStartTouchY else { return }
        let delta = touch.location(in: self).y - dragStartTouchY
        if abs(delta) > 8 { didDragPastTapThreshold = true }
        contentNode.position.y = max(0, min(maxContentY, contentYAtDragStart + delta))
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        defer { dragStartTouchY = nil }
        guard bonusPopup == nil else { return }
        guard let touch = touches.first, !didDragPastTapThreshold else { return }

        let node = atPoint(touch.location(in: self))
        let name = node.name ?? ""

        if name == "timerBonusButton" {
            collectTimerBonusIfReady()
            return
        }

        guard name.hasPrefix("machine_"),
              let machineID = Int(name.dropFirst("machine_".count)),
              let machine = machines.first(where: { $0.id == machineID }),
              machine.isOpen(walletLevel: walletLevel)
        else { return }
        onSelectMachine?(machine)
    }

    private func collectTimerBonusIfReady() {
        guard let bonusStore, let walletStore, BonusEligibility.isTimerBonusReady(bonusStore.state) else { return }
        var awarded = 0.0
        bonusStore.update { awarded = BonusEligibility.collectTimerBonus(&$0, level: walletLevel) }
        walletStore.update { $0.balance += awarded }
        refreshTimerBonusButton()
    }
}
