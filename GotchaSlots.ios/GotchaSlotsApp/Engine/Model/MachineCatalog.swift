import Foundation

/// Ports Main.as's InitMachines(): the roster of machines the lobby can show. Loads every
/// machine-config `.json` resource in the bundle — all 42 real machine entries from
/// InitMachines() (Classic 5x3 and 5x5 hand-authored in Phase 1/5, the other 40 transcribed
/// programmatically in Phase 7 the same way Phase 2's paylines were: a script over Main.as +
/// LobbyMachineNormalSymbolsData.as, not by hand, to cut transcription-error risk).
/// `InitMachines()`'s one non-playable entry, `ComingSoonDummyData` (id 600, no grid shape, no
/// feature flags, no bonus config — a degenerate system placeholder, not a real machine), isn't
/// represented here; it doesn't fit the MachineConfiguration model and has no gameplay of its
/// own to port.
enum MachineCatalog {
    static func loadAll(bundle: Bundle = .main) -> [MachineConfiguration] {
        // Xcode/XcodeGen resource copying doesn't reliably preserve the `MachineConfigs/`
        // subdirectory (observed: files land flattened at the bundle root instead — see
        // MachineConfigurationLoader's identical fallback from Phase 1). Try the "proper"
        // subdirectory-scoped lookup first, and fall back to scanning every .json resource in
        // the bundle otherwise. The fallback is safe to run against the WHOLE bundle (which
        // also contains the unrelated CurtainSkins/*.json resources) because CurtainSkinConfig
        // and MachineConfiguration have disjoint required fields — a curtain skin's JSON simply
        // fails to decode as a MachineConfiguration and `compactMap` drops it.
        var urls = bundle.urls(forResourcesWithExtension: "json", subdirectory: "MachineConfigs") ?? []
        if urls.isEmpty {
            urls = bundle.urls(forResourcesWithExtension: "json", subdirectory: nil) ?? []
        }

        let decoder = JSONDecoder()
        return urls.compactMap { url in
            guard let data = try? Data(contentsOf: url) else { return nil }
            return try? decoder.decode(MachineConfiguration.self, from: data)
        }
        .sorted { $0.id < $1.id }
    }
}
