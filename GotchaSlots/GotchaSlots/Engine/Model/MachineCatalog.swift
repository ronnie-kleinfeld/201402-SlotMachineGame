import Foundation

/// Ports Main.as's InitMachines(): the roster of machines the lobby can show. Currently lists
/// just "classic_5x3" (Phase 1's fixture) — the other 44 machines from the original's
/// InitMachines() are Phase 7 bulk data-entry work; this loader doesn't need to change shape
/// when those are added, just this list of resource names.
///
/// NOTE: classic_5x3.json's `openOnLevel` is set to 1, not the real game's 150 — there's no
/// leveling/progression system yet, so the authentic value would leave the lobby with zero
/// reachable machines. Restore 150 (and add real progression) once a leveling system exists,
/// or once enough lower-`openOnLevel` machines are ported that this one no longer needs to be
/// reachable from a fresh wallet.
enum MachineCatalog {
    private static let resourceNames = ["classic_5x3"]

    static func loadAll(bundle: Bundle = .main) -> [MachineConfiguration] {
        resourceNames.compactMap { name in
            try? MachineConfigurationLoader.load(named: name, in: bundle)
        }
    }
}
