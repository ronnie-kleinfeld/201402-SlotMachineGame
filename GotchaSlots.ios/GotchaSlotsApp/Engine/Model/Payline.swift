import Foundation

/// Ports BasePaylineData/Payline5Data: an ordered list of grid-cell indices, one per column,
/// that a payline traverses left to right. `cells.count` must equal the grid's column count.
struct Payline: Codable, Identifiable {
    let id: Int
    let color: Int
    let cells: [Int]
}
