import Foundation

/// Mirrors the AS3 grid-shape hierarchy (LobbyMachine3x3Data / 5x1 / 5x3 / 5x4 / 5x5Data).
enum GridShape: String, Codable {
    case grid3x3
    case grid5x1
    case grid5x3
    case grid5x4
    case grid5x5

    var rows: Int {
        switch self {
        case .grid3x3: return 3
        case .grid5x1: return 1
        case .grid5x3: return 3
        case .grid5x4: return 4
        case .grid5x5: return 5
        }
    }

    var columns: Int {
        switch self {
        case .grid3x3: return 3
        case .grid5x1, .grid5x3, .grid5x4, .grid5x5: return 5
        }
    }

    var cellCount: Int { rows * columns }
}
