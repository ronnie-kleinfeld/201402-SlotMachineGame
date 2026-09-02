import Foundation

/// A value persisted via KeychainStore must supply what a fresh install starts with — ports the
/// role of each concrete BaseIOData subclass's `Init()` override.
protocol PersistedState: Codable {
    static var defaultValue: Self { get }
}

/// Ports BaseIOData's Load/Save pattern onto the iOS Keychain (replacing AS3's
/// `flash.data.EncryptedLocalStore`, which is itself Keychain-backed on iOS — this is a direct
/// port, not a reinterpretation):
///   - `load()`: read by key; if present, decode it; if absent OR decode fails, fall back to
///     `State.defaultValue` and immediately persist that default (ports `Init(); Save();` in
///     AS3's `Load()`, including its `catch` branch — AS3's catch calls `Init()` but NOT
///     `Save()`, a detail worth preserving: a corrupt read is recovered in-memory but the
///     corrupt data on disk isn't overwritten until something else triggers a save).
///   - `save()`: only writes if `load()` has actually run at least once — ports the
///     `_initialized` guard, preventing a save from clobbering real stored data with whatever
///     default the in-memory `state` happened to hold before Load() was called.
final class KeychainStore<State: PersistedState> {
    private let key: String
    private(set) var state: State
    private var isInitialized = false

    init(key: String) {
        self.key = key
        self.state = State.defaultValue
    }

    func load() {
        if let data = KeychainHelper.read(key: key) {
            do {
                state = try JSONDecoder().decode(State.self, from: data)
                isInitialized = true
            } catch {
                // Ports AS3's catch branch: recover in-memory only, don't overwrite the stored
                // (corrupt) bytes yet.
                state = State.defaultValue
            }
        } else {
            state = State.defaultValue
            isInitialized = true
            save()
        }
    }

    func save() {
        guard isInitialized else { return }
        guard let data = try? JSONEncoder().encode(state) else { return }
        KeychainHelper.write(key: key, data: data)
    }

    func update(_ mutate: (inout State) -> Void) {
        mutate(&state)
        save()
    }
}
