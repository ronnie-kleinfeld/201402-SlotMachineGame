import SpriteKit

/// Renders a symbol using its real art (imported from the AS3 asset projects) when a matching
/// image exists in the asset catalog, falling back to a colored placeholder tile otherwise —
/// most machines still don't have their art imported (only Classic's does so far), so both
/// paths need to keep working side by side rather than assuming art is always present.
final class SymbolNode: SKNode {
    private let tile: SKShapeNode
    private let label: SKLabelNode
    private var sprite: SKSpriteNode?

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
        if let image = UIImage(named: symbol.assetName) {
            tile.fillColor = SKColor(white: 0.12, alpha: 1)
            label.text = ""
            showSprite(image: image)
        } else {
            tile.fillColor = isWild ? SKColor.systemYellow.withAlphaComponent(0.85) : Self.color(forSymbolID: symbol.id)
            label.text = isWild ? "WILD" : symbol.assetName.replacingOccurrences(of: "Classic_", with: "")
            sprite?.removeFromParent()
            sprite = nil
        }
    }

    private func showSprite(image: UIImage) {
        let texture = SKTexture(image: image)
        let node: SKSpriteNode
        if let existing = sprite {
            node = existing
            node.texture = texture
        } else {
            node = SKSpriteNode(texture: texture)
            addChild(node)
            sprite = node
        }

        // Fit within the tile with a small inset, preserving the source image's aspect ratio.
        let inset: CGFloat = 8
        let maxSize = CGSize(width: Self.size.width - inset * 2, height: Self.size.height - inset * 2)
        let imageSize = texture.size()
        let scale = min(maxSize.width / imageSize.width, maxSize.height / imageSize.height)
        node.size = CGSize(width: imageSize.width * scale, height: imageSize.height * scale)
    }

    private static func color(forSymbolID id: Int) -> SKColor {
        let hue = CGFloat(id % 10) / 10.0
        return SKColor(hue: hue, saturation: 0.55, brightness: 0.85, alpha: 1.0)
    }
}
