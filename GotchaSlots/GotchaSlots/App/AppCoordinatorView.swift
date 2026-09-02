import SwiftUI
import SpriteKit

/// Top-level scene host. Phase 1 hardcodes entry into Classic 5x3 (no lobby yet — see
/// Phase 5 of the plan). Falls back to a placeholder scene if the machine config fails to
/// load, so a resource-bundling mistake shows up as an obvious on-screen message rather than
/// a silent blank screen.
struct AppCoordinatorView: View {
    // Built once as a @State default value, not a computed property — SwiftUI re-evaluates
    // `body` far more often than once, and a computed `scene` handed a fresh SKScene to
    // SpriteView on every evaluation, thrashing the SKView (background color survives because
    // it's set synchronously in didMove, but child nodes never survive to a render pass before
    // the next replacement scene arrives).
    @State private var scene: SKScene = Self.makeScene()

    private static func makeScene() -> SKScene {
        let scene: SKScene
        do {
            let machine = try MachineConfigurationLoader.load(named: "classic_5x3")
            scene = MachineScene(machine: machine)
        } catch {
            scene = PlaceholderScene(size: CGSize(width: 750, height: 1334), message: "Failed to load classic_5x3.json:\n\(error)")
        }
        // .aspectFit (not .aspectFill) so the whole 750x1334 scene is always visible —
        // .aspectFill previously cropped most of the scene away when the device's actual
        // aspect ratio didn't match, which is what caused the HUD/grid/button to appear
        // entirely missing (see AppCoordinatorView git history / the orientation fix).
        scene.scaleMode = .aspectFit
        return scene
    }

    var body: some View {
        SpriteView(scene: scene)
            .ignoresSafeArea()
    }
}

/// Fallback scene shown only if the machine config resource fails to load.
final class PlaceholderScene: SKScene {
    private let message: String

    init(size: CGSize, message: String) {
        self.message = message
        super.init(size: size)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func didMove(to view: SKView) {
        backgroundColor = .black
        let label = SKLabelNode(text: message)
        label.fontSize = 22
        label.numberOfLines = 0
        label.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(label)
    }
}
