import SpriteKit

/// Phase 1's minimal machine screen: the Classic 5x3 grid, a spin button, and a balance/bet
/// readout. No lobby yet (Phase 5) — the app enters directly into this scene.
final class MachineScene: SKScene {
    private let machine: MachineConfiguration
    private let bag: SymbolBag
    private let paylines: [Payline]
    private let stateMachine: SpinStateMachine

    private var reels: [ReelNode] = []
    private var balanceLabel: SKLabelNode!
    private var resultLabel: SKLabelNode!
    private var spinButton: SKShapeNode!
    private var isSpinning = false

    private let selectedPaylines = 20
    private let selectedBetChips = 1.0

    init(machine: MachineConfiguration) {
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
            selectedPaylines: selectedPaylines,
            selectedBetChips: selectedBetChips,
            startingBalance: 1000
        )
        super.init(size: CGSize(width: 750, height: 1334))
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func didMove(to view: SKView) {
        backgroundColor = SKColor(red: 0.08, green: 0.1, blue: 0.16, alpha: 1)
        buildGrid()
        buildHUD()
        buildSpinButton()
        updateBalanceLabel()
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
        if node.name == "spinButton" {
            handleSpinTapped()
        }
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
            updateBalanceLabel()
            isSpinning = false
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
