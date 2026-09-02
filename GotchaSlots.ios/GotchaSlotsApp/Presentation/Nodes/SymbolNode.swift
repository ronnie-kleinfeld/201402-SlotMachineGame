import SpriteKit

/// Placeholder symbol rendering (a colored tile + label) until real art is extracted from the
/// Flex asset projects (deferred — see the plan's Phase 7). Keeps the reel/grid/spin loop
/// visually verifiable without blocking Phase 1 on art pipeline work.
final class SymbolNode: SKNode {
    private let tile: SKShapeNode
    private let label: SKLabelNode

    static let size = CGSize(width: 120, height: 76)

    override init() {
        tile = SKShapeNode(rectOf: Self.size, cornerRadius: 8)
        label = SKLabelNode(fontNamed: "HelveticaNeue-Bold")
        super.init()

        tile.strokeColor = .white
        tile.lineWidth = 1
        addChild(tile)

        label.fontSize = 20
        label.verticalAlignmentMode = .center
        label.horizontalAlignmentMode = .center
        addChild(label)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func configure(symbol: SymbolConfig, isWild: Bool) {
        label.text = isWild ? "WILD" : symbol.assetName.replacingOccurrences(of: "Classic_", with: "")
        tile.fillColor = isWild ? SKColor.systemYellow.withAlphaComponent(0.85) : Self.color(forSymbolID: symbol.id)
    }

    private static func color(forSymbolID id: Int) -> SKColor {
        let hue = CGFloat(id % 10) / 10.0
        return SKColor(hue: hue, saturation: 0.55, brightness: 0.85, alpha: 1.0)
    }
}
