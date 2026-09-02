import Foundation

/// Wraps whichever bonus-game family is currently in progress, so SpinStateMachine and the
/// presentation layer have one type to hold regardless of which minigame a machine launches —
/// ports the BaseBonusGameData/BaseBonusGameEngine split's role of hiding which concrete bonus
/// game is active behind a common interface.
enum ActiveBonusGame {
    case curtain(CurtainGameState)
    case higherLower(HigherLowerGameState)

    var isOver: Bool {
        switch self {
        case .curtain(let state): return state.isOver
        case .higherLower(let state): return state.isOver
        }
    }

    func chipsWon(selectedBetChips: Double) -> Double {
        switch self {
        case .curtain(let state): return state.chipsWon(selectedBetChips: selectedBetChips)
        case .higherLower(let state): return state.chipsWon(selectedBetChips: selectedBetChips)
        }
    }

    /// Returns nil if `kind` names a curtain skin whose resource fails to load — a config/asset
    /// error, not a gameplay outcome, so callers should treat nil as "don't start a bonus game"
    /// rather than crash.
    static func make(kind: BonusGameKind) -> ActiveBonusGame? {
        switch kind.family {
        case .curtain:
            guard let skin = kind.skin, let config = try? CurtainSkinCatalog.load(skin: skin) else {
                return nil
            }
            return .curtain(CurtainGameState(levels: config.makeLevels()))
        case .higherLower:
            return .higherLower(HigherLowerGameState())
        }
    }
}
