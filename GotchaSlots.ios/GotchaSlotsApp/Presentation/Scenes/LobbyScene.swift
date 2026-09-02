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

    init(machines: [MachineConfiguration], walletLevel: Int) {
        self.machines = machines
        self.walletLevel = walletLevel
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

        addChild(contentNode)
        buildMachineTiles()
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

            let nameLabel = SKLabelNode(text: machine.machineName)
            nameLabel.fontName = "HelveticaNeue-Bold"
            nameLabel.fontSize = 28
            nameLabel.fontColor = .white
            nameLabel.position = CGPoint(x: 0, y: 15)
            nameLabel.name = tile.name
            tile.addChild(nameLabel)

            let statusText = isOpen
                ? "Grid \(machine.gridShape.rows)x\(machine.gridShape.columns) · \(machine.maxPaylines) lines"
                : machine.lockedMessage(walletLevel: walletLevel)
            let statusLabel = SKLabelNode(text: statusText)
            statusLabel.fontName = "HelveticaNeue"
            statusLabel.fontSize = 18
            statusLabel.fontColor = SKColor(white: 0.9, alpha: 1)
            statusLabel.position = CGPoint(x: 0, y: -22)
            statusLabel.name = tile.name
            tile.addChild(statusLabel)
        }

        let lastTileBottomLocalY = startY - CGFloat(max(machines.count - 1, 0)) * step - tileSize.height / 2
        maxContentY = max(0, Self.visibleBottomMargin - lastTileBottomLocalY)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        dragStartTouchY = touch.location(in: self).y
        contentYAtDragStart = contentNode.position.y
        didDragPastTapThreshold = false
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let dragStartTouchY else { return }
        let delta = touch.location(in: self).y - dragStartTouchY
        if abs(delta) > 8 { didDragPastTapThreshold = true }
        contentNode.position.y = max(0, min(maxContentY, contentYAtDragStart + delta))
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        defer { dragStartTouchY = nil }
        guard let touch = touches.first, !didDragPastTapThreshold else { return }

        let node = atPoint(touch.location(in: self))
        guard let name = node.name, name.hasPrefix("machine_"),
              let machineID = Int(name.dropFirst("machine_".count)),
              let machine = machines.first(where: { $0.id == machineID }),
              machine.isOpen(walletLevel: walletLevel)
        else { return }
        onSelectMachine?(machine)
    }
}
