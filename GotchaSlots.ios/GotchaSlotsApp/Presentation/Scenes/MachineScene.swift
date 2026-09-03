import SpriteKit

/// The machine screen: a grid, a spin button, and a balance/bet readout. Entered from
/// LobbyScene (Phase 5) via AppCoordinator; `onExit` returns there.
final class MachineScene: SKScene {
    private let machine: MachineConfiguration
    private let bag: SymbolBag
    private let paylines: [Payline]
    private let stateMachine: SpinStateMachine
    private let purchaseManager: PurchaseManager?
    var onExit: (() -> Void)?

    private var reels: [ReelNode] = []
    private var balanceLabel: SKLabelNode!
    private var resultLabel: SKLabelNode!
    private var spinButton: SKShapeNode!
    private var backButton: SKShapeNode!
    private var buyChipsButton: SKShapeNode!
    private var buyChipsOverlay: BuyChipsOverlay?
    private var bonusGameOverlay: BonusGameOverlay?
    private var isSpinning = false

    private let selectedPaylines = 20
    private let selectedBetChips = 1.0

    init(machine: MachineConfiguration, walletStore: KeychainStore<WalletState>? = nil) {
        self.machine = machine
        self.bag = SymbolBag(
            normalSymbols: machine.normalSymbols, wild: machine.wild, factor: machine.factor,
            freeSpins: machine.freeSpins, bomb: machine.bomb, miniSpin: machine.miniSpin,
            bonusGame: machine.bonusGame, multiplier: machine.multiplier,
            ace: machine.ace, gold: machine.gold, king: machine.king
        )
        self.paylines = Array(PaylineSet.all(for: machine.gridShape).prefix(machine.maxPaylines))
        let resolver = SpinResolver(machine: machine, bag: bag, paylines: paylines, diagonalWinLimitChips: 500)
        self.stateMachine = SpinStateMachine(
            resolver: resolver,
            gridShape: machine.gridShape,
            bonusGameKind: machine.bonusGameKind,
            selectedPaylines: selectedPaylines,
            selectedBetChips: selectedBetChips,
            startingBalance: 1000,
            walletStore: walletStore
        )
        self.purchaseManager = walletStore.map { PurchaseManager(walletStore: $0) }
        super.init(size: CGSize(width: 750, height: 1334))
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func didMove(to view: SKView) {
        backgroundColor = SKColor(red: 0.08, green: 0.1, blue: 0.16, alpha: 1)
        buildGrid()
        buildHUD()
        buildSpinButton()
        buildBackButton()
        updateBalanceLabel()
    }

    private func buildBackButton() {
        backButton = SKShapeNode(rectOf: CGSize(width: 90, height: 50), cornerRadius: 10)
        backButton.fillColor = SKColor(white: 1, alpha: 0.15)
        backButton.strokeColor = .white
        backButton.lineWidth = 1.5
        backButton.position = CGPoint(x: 70, y: size.height * 0.95)
        backButton.name = "backButton"
        addChild(backButton)

        let label = SKLabelNode(text: "< Lobby")
        label.fontName = "HelveticaNeue-Bold"
        label.fontSize = 18
        label.fontColor = .white
        label.verticalAlignmentMode = .center
        label.name = "backButton"
        backButton.addChild(label)
    }

    private func buildGrid() {
        let shape = machine.gridShape
        let spacing = SymbolNode.size.width + 12
        let gridWidth = CGFloat(shape.columns) * spacing
        let originX = (size.width - gridWidth) / 2 + spacing / 2
        let gridTopY = size.height * 0.72

        for column in 0..<shape.columns {
            let reel = ReelNode(columnIndex: column, rowCount: shape.rows)
            reel.position = CGPoint(x: originX + CGFloat(column) * spacing, y: gridTopY)
            addChild(reel)
            reels.append(reel)
        }
    }

    private func buildHUD() {
        balanceLabel = SKLabelNode(fontNamed: "HelveticaNeue-Bold")
        balanceLabel.fontSize = 28
        balanceLabel.fontColor = .white
        balanceLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.88)
        balanceLabel.zPosition = 500
        addChild(balanceLabel)

        resultLabel = SKLabelNode(fontNamed: "HelveticaNeue")
        resultLabel.fontSize = 22
        resultLabel.fontColor = .systemYellow
        resultLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.30)
        resultLabel.zPosition = 500
        addChild(resultLabel)

        buyChipsButton = SKShapeNode(rectOf: CGSize(width: 120, height: 44), cornerRadius: 10)
        buyChipsButton.fillColor = SKColor.systemYellow.withAlphaComponent(0.9)
        buyChipsButton.strokeColor = .white
        buyChipsButton.lineWidth = 1.5
        buyChipsButton.position = CGPoint(x: size.width - 90, y: size.height * 0.95)
        buyChipsButton.name = "buyChipsButton"
        buyChipsButton.zPosition = 500
        addChild(buyChipsButton)

        let buyLabel = SKLabelNode(text: "+ Chips")
        buyLabel.fontName = "HelveticaNeue-Bold"
        buyLabel.fontSize = 18
        buyLabel.fontColor = .black
        buyLabel.verticalAlignmentMode = .center
        buyLabel.name = "buyChipsButton"
        buyChipsButton.addChild(buyLabel)
    }

    private func buildSpinButton() {
        spinButton = SKShapeNode(circleOfRadius: 60)
        spinButton.fillColor = .systemGreen
        spinButton.strokeColor = .white
        spinButton.lineWidth = 3
        spinButton.position = CGPoint(x: size.width / 2, y: size.height * 0.14)
        spinButton.name = "spinButton"
        spinButton.zPosition = 500
        addChild(spinButton)

        let label = SKLabelNode(text: "SPIN")
        label.fontName = "HelveticaNeue-Bold"
        label.fontSize = 24
        label.fontColor = .white
        label.verticalAlignmentMode = .center
        label.name = "spinButton"
        spinButton.addChild(label)
    }

    private func updateBalanceLabel() {
        balanceLabel.text = "Balance: \(Int(stateMachine.balance))   Bet: \(Int(selectedBetChips * Double(selectedPaylines)))"
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let node = atPoint(location)
        let name = node.name ?? ""

        if let overlay = bonusGameOverlay {
            _ = overlay.handleTap(nodeName: name)
            return
        }

        if let overlay = buyChipsOverlay {
            _ = overlay.handleTap(nodeName: name)
            return
        }

        if name == "spinButton" {
            handleSpinTapped()
        } else if name == "backButton" {
            onExit?()
        } else if name == "buyChipsButton" {
            showBuyChips()
        }
    }

    private func showBuyChips() {
        guard buyChipsOverlay == nil, let purchaseManager else { return }
        let overlay = BuyChipsOverlay(sceneSize: size, purchaseManager: purchaseManager)
        overlay.onDismiss = { [weak self] in self?.dismissBuyChips() }
        overlay.onPurchaseSucceeded = { [weak self] in self?.updateBalanceLabel() }
        addChild(overlay)
        buyChipsOverlay = overlay
    }

    private func dismissBuyChips() {
        buyChipsOverlay?.removeFromParent()
        buyChipsOverlay = nil
        updateBalanceLabel()
    }

    private func showBonusGame() {
        guard bonusGameOverlay == nil else { return }
        let overlay = BonusGameOverlay(sceneSize: size, stateMachine: stateMachine)
        overlay.onDismiss = { [weak self] chipsWon in self?.dismissBonusGame(chipsWon: chipsWon) }
        addChild(overlay)
        bonusGameOverlay = overlay
    }

    private func dismissBonusGame(chipsWon: Double) {
        bonusGameOverlay?.removeFromParent()
        bonusGameOverlay = nil
        // Settling the bonus game may have resumed a free-spins sequence that was paused for
        // it (SpinStateMachine.settleBonusGameIfOver -> playPendingFreeSpins), which can change
        // both the grid and the balance further — reflect that final state, not the grid as it
        // was when the bonus game started.
        if let result = stateMachine.lastResult {
            render(result: result)
        }
        if let summary = stateMachine.lastFreeSpinsSummary {
            resultLabel.text = "Free Spins: \(summary.spinsPlayed) spins, +\(Int(summary.chipsWon)) chips"
        } else {
            resultLabel.text = "Bonus Game: +\(Int(chipsWon)) chips"
        }
        updateBalanceLabel()
    }

    private func handleSpinTapped() {
        guard !isSpinning else { return }
        isSpinning = true
        resultLabel.text = ""

        Task { @MainActor in
            await stateMachine.spin()
            if let result = stateMachine.lastResult {
                render(result: result)
            }
            if let summary = stateMachine.lastFreeSpinsSummary {
                resultLabel.text = "Free Spins: \(summary.spinsPlayed) spins, +\(Int(summary.chipsWon)) chips"
            }
            updateBalanceLabel()
            isSpinning = false
            if stateMachine.activeBonusGame != nil {
                showBonusGame()
            }
        }
    }

    private func render(result: SpinResult) {
        let shape = machine.gridShape
        for column in 0..<shape.columns {
            var columnSymbols: [(SymbolConfig, isWild: Bool)] = []
            for row in 0..<shape.rows {
                let cellIndex = row * shape.columns + column
                let symbolID = result.matrix.cells[cellIndex] ?? bag.wild.id
                let isWild = symbolID == bag.wild.id
                let symbol = bag.symbol(withID: symbolID) ?? bag.wild
                columnSymbols.append((symbol, isWild))
            }
            reels[column].spin(finalSymbols: columnSymbols)
        }

        if result.payout.isValuable {
            resultLabel.text = "WIN! +\(Int(result.payout.totalChips)) chips"
        } else {
            resultLabel.text = "No win"
        }
    }
}
