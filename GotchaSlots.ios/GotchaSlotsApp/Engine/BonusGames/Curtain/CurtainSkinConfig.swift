import Foundation

/// Ports one CurtainLevelData literal (`new CurtainLevelData(id, bgClass, mapMessage,
/// tickerMessage, selectiveItemsCount, disposeLevelOnComplete)` + its N `CurtainItems.push(...)`
/// calls) as data. `itemCount` is all that matters for game logic — each item's payout/failure
/// status is randomized independently at construction (CurtainItem.init(id:)), not stored here;
/// art/position data from the AS3 source isn't ported (no visual layout yet).
struct CurtainLevelConfig: Codable {
    let id: Int
    let mapMessage: String
    let tickerMessage: String
    let itemCount: Int
    let selectiveItemsCount: Int
}

/// Ports one `Xxx CurtainData` class (e.g. HolidayCurtainData, CarCurtainData) — a themed skin
/// for the generic curtain pick-a-box engine (CurtainGameState). All 15 skins share identical
/// game logic; only this data differs per skin.
struct CurtainSkinConfig: Codable {
    let startPopupMessage: String
    let levels: [CurtainLevelConfig]

    /// Builds a fresh, randomized runtime `CurtainLevel` array — ports InitLevelsAndItems being
    /// called anew each time a bonus game starts (every CurtainItem gets a fresh random
    /// payout/isFailure roll, matching the AS3 behavior of constructing new item data per
    /// bonus-game session).
    func makeLevels() -> [CurtainLevel] {
        levels.map { config in
            CurtainLevel(
                id: config.id,
                mapMessage: config.mapMessage,
                tickerMessage: config.tickerMessage,
                items: (0..<config.itemCount).map { CurtainItem(id: $0) },
                selectiveItemsCount: config.selectiveItemsCount
            )
        }
    }
}

/// Ports the roster of curtain skins (Holiday + the 14 other `Xxx CurtainData` classes) as a
/// bundle-resource catalog, mirroring MachineCatalog's pattern — one generic engine
/// (CurtainGameState), data-driven per skin, not a Swift subclass per skin.
enum CurtainSkinCatalog {
    enum LoadError: Error {
        case resourceNotFound(String)
    }

    static func load(skin: String, bundle: Bundle = .main) throws -> CurtainSkinConfig {
        guard let url = bundle.url(forResource: skin, withExtension: "json", subdirectory: "CurtainSkins")
            ?? bundle.url(forResource: skin, withExtension: "json")
        else {
            throw LoadError.resourceNotFound(skin)
        }
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(CurtainSkinConfig.self, from: data)
    }
}
