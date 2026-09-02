import SwiftUI
import SpriteKit

/// Top-level scene host. Phase 5: hosts AppCoordinator's current scene (Lobby or Machine),
/// switching whenever the coordinator navigates. `@StateObject` (not a computed property) is
/// what keeps this from recreating the coordinator — and therefore reloading the wallet and
/// rebuilding scenes — on every body evaluation.
struct AppCoordinatorView: View {
    @StateObject private var coordinator = AppCoordinator()

    var body: some View {
        SpriteView(scene: coordinator.scene)
            .ignoresSafeArea()
    }
}

/// Fallback scene shown when a machine config resource fails to load or the catalog is empty,
/// so a resource-bundling mistake shows up as an obvious on-screen message rather than a
/// silent blank screen.
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
