import SpriteKit

/// Ports Reel.as's core idea: the RNG result is computed before any animation starts, and the
/// "spin" is a purely cosmetic reveal. This tweens a column of SymbolNodes into place rather
/// than genuinely randomizing during the animation.
final class ReelNode: SKNode {
    private let columnIndex: Int
    private let rowCount: Int
    private var symbolNodes: [SymbolNode] = []

    init(columnIndex: Int, rowCount: Int) {
        self.columnIndex = columnIndex
        self.rowCount = rowCount
        super.init()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    /// `finalSymbols` are the already-resolved row values for this column, top to bottom.
    /// Ports Reel.as's per-column stagger (`delay: 0.2 + column/20`) and Back-ease reveal.
    func spin(finalSymbols: [(SymbolConfig, isWild: Bool)]) {
        symbolNodes.forEach { $0.removeFromParent() }
        symbolNodes.removeAll()

        let spacing = SymbolNode.size.height + 8
        let startY: CGFloat = CGFloat(rowCount) * spacing // start off-screen above, tween down into place

        for (row, (symbol, isWild)) in finalSymbols.enumerated() {
            let node = SymbolNode()
            node.configure(symbol: symbol, isWild: isWild)
            let targetY = -CGFloat(row) * spacing
            node.position = CGPoint(x: 0, y: startY)
            addChild(node)
            symbolNodes.append(node)

            let delay = 0.15 + Double(columnIndex) / 12.0
            let move = SKAction.move(to: CGPoint(x: 0, y: targetY), duration: 0.5)
            move.timingMode = .easeOut
            node.run(.sequence([.wait(forDuration: delay), move]))
        }
    }
}
