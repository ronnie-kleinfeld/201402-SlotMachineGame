import Foundation

/// Ports HolidayCurtainData.InitLevelsAndItems: 4 themed levels (Chinese, FourOfJuly,
/// Hanukkah, ThanksGiving), each with `selectiveItemsCount: 1` — pick exactly one item to clear
/// the level. Item art positions from the AS3 source aren't ported (no visual layout yet); only
/// the item COUNT per level matters for game logic, since each item's payout/failure status is
/// randomized independently at construction (see CurtainItem).
enum HolidayCurtainConfig {
    static func makeLevels() -> [CurtainLevel] {
        let itemCountsByTheme: [(name: String, itemCount: Int)] = [
            ("Chinese", 5),
            ("FourOfJuly", 6),
            ("Hanukkah", 6),
            ("ThanksGiving", 4),
        ]

        return itemCountsByTheme.enumerated().map { levelIndex, theme in
            CurtainLevel(
                id: levelIndex,
                mapMessage: "Holiday",
                tickerMessage: "Select an \(theme.name)",
                items: (0..<theme.itemCount).map { CurtainItem(id: $0) },
                selectiveItemsCount: 1
            )
        }
    }
}
