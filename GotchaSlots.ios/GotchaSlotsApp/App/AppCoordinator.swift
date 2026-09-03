import SpriteKit

/// Ports MainPanel's role of coordinating Lobby <-> Machine transitions off Main.Instance
/// events. Owns the wallet store (loaded once, persisted across the whole session) and the
/// current scene; `scene` is `@Published` and reassigned only on an actual navigation, never
/// recreated per-render — see AppCoordinatorView's history for why that distinction matters
/// (a computed-property scene thrashed SpriteView and made content silently vanish).
@MainActor
final class AppCoordinator: ObservableObject {
    @Published private(set) var scene: SKScene

    private let walletStore: KeychainStore<WalletState>
    private let bonusStore: KeychainStore<BonusState>
    private let catalog: [MachineConfiguration]
    private static let sceneSize = CGSize(width: 750, height: 1334)

    init() {
        let walletStore = KeychainStore<WalletState>(key: "com.gotchaslots.wallet")
        walletStore.load()
        self.walletStore = walletStore
        let bonusStore = KeychainStore<BonusState>(key: "com.gotchaslots.bonuses")
        bonusStore.load()
        self.bonusStore = bonusStore
        self.catalog = MachineCatalog.loadAll()

        // Placeholder to satisfy Swift's "all stored properties assigned" rule before any
        // instance method can be called; immediately replaced below.
        self.scene = Self.makePlaceholder(message: "")

        scene = catalog.isEmpty
            ? Self.makePlaceholder(message: "No machine configs found in the bundle.")
            : makeLobbyScene()
    }

    private func makeLobbyScene() -> SKScene {
        let lobby = LobbyScene(
            machines: catalog, walletLevel: walletStore.state.level,
            walletStore: walletStore, bonusStore: bonusStore
        )
        lobby.scaleMode = .aspectFit
        lobby.onSelectMachine = { [weak self] machine in self?.showMachine(machine) }
        return lobby
    }

    func showLobby() {
        scene = makeLobbyScene()
    }

    func showMachine(_ machine: MachineConfiguration) {
        let machineScene = MachineScene(machine: machine, walletStore: walletStore)
        machineScene.scaleMode = .aspectFit
        machineScene.onExit = { [weak self] in self?.showLobby() }
        scene = machineScene
    }

    private static func makePlaceholder(message: String) -> SKScene {
        let scene = PlaceholderScene(size: sceneSize, message: message)
        scene.scaleMode = .aspectFit
        return scene
    }
}
