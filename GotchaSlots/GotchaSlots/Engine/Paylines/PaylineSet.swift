import Foundation

/// Picks the right hardcoded payline table for a machine's grid shape — ports the pattern in
/// SlotsBaseLobbyMachineData/LobbyMachine{Shape}Data where each grid-size subclass binds its
/// own `PaylinesClass` (Paylines3x3Data, Paylines5x1Data, Paylines5x3Data, Paylines5x4Data,
/// Paylines5x5Data). One generic engine, per-shape data — not a Swift subclass per shape.
enum PaylineSet {
    /// All paylines for `shape`, in AS3 array/ID order. Callers wanting fewer active lines
    /// should take a `prefix` of this (mirrors BasePaylinesData truncating to `maxPaylines`).
    static func all(for shape: GridShape) -> [Payline] {
        switch shape {
        case .grid3x3: return paylines3x3
        case .grid5x1: return paylines5x1
        case .grid5x3: return paylines5x3
        case .grid5x4: return paylines5x4
        case .grid5x5: return paylines5x5
        }
    }
}
