import Foundation

/// Ports BaseCurtainItemData: each item's payout and failure status are randomized ONCE at
/// construction (not per-pick), so the layout is fixed for the whole level as soon as it's
/// built — a player picking a different item would see a different fixed outcome, not a fresh
/// roll. `payout` is ceil(random * 9) (1...9); `isFailure` is a flat 30% chance, ported
/// specifically from the AS3 mobile branch (`Main.Instance.Device.IsMobile ? random < 0.3 :
/// false` — the non-mobile branch, always-false, is unreachable for this iOS-only port).
struct CurtainItem: Identifiable {
    let id: Int
    let payout: Int
    let isFailure: Bool
    var isSelected: Bool = false

    init(id: Int) {
        self.id = id
        self.payout = Int(ceil(Double.random(in: 0..<1) * 9))
        self.isFailure = Double.random(in: 0..<1) < 0.3
    }

    /// Deterministic construction for tests — production code always uses `init(id:)`, which
    /// ports the AS3 random-at-construction behavior.
    init(id: Int, payout: Int, isFailure: Bool) {
        self.id = id
        self.payout = payout
        self.isFailure = isFailure
    }
}

/// Ports CurtainLevelData: one themed screen of pickable items. `selectiveItemsCount` is how
/// many NON-failure items the player must pick to clear the level (every curtain skin observed
/// in the AS3 source uses 1, but the field isn't hardcoded to that).
struct CurtainLevel {
    let id: Int
    let mapMessage: String
    let tickerMessage: String
    var items: [CurtainItem]
    let selectiveItemsCount: Int

    var selectedItemsCount: Int { items.filter(\.isSelected).count }
}

enum CurtainOutcome: Equatable {
    case pending
    case levelCleared
    case failed
    case allLevelsCleared
}

/// Ports BaseCurtainData + LevelBox's pick-handling (onItemClicked): an "advent calendar" style
/// bonus game — clear each level by picking one non-failure item (per its
/// `selectiveItemsCount`), collecting that item's payout; picking a failure item ends the whole
/// bonus game immediately, keeping only what was already collected from cleared levels.
struct CurtainGameState {
    private(set) var levels: [CurtainLevel]
    private(set) var currentLevelIndex: Int = 0
    private(set) var isOver: Bool = false

    init(levels: [CurtainLevel]) {
        self.levels = levels
    }

    var currentLevel: CurtainLevel? {
        guard levels.indices.contains(currentLevelIndex) else { return levels.last }
        return levels[currentLevelIndex]
    }

    /// Ports LevelBox.onItemClicked: marks the item selected, and either fails the whole game
    /// (a failure item), clears the current level (selectiveItemsCount reached), or leaves the
    /// level in progress (more non-failure picks still needed).
    mutating func pick(itemID: Int) -> CurtainOutcome {
        guard !isOver, levels.indices.contains(currentLevelIndex) else { return .failed }
        guard let itemIndex = levels[currentLevelIndex].items.firstIndex(where: { $0.id == itemID }),
              !levels[currentLevelIndex].items[itemIndex].isSelected
        else { return .pending }

        levels[currentLevelIndex].items[itemIndex].isSelected = true
        let item = levels[currentLevelIndex].items[itemIndex]

        if item.isFailure {
            isOver = true
            return .failed
        }

        guard levels[currentLevelIndex].selectedItemsCount == levels[currentLevelIndex].selectiveItemsCount else {
            return .pending
        }

        currentLevelIndex += 1
        if currentLevelIndex >= levels.count {
            isOver = true
            return .allLevelsCleared
        }
        return .levelCleared
    }

    /// Ports BaseCurtainData.CalculateChipsWon: sums the payout of every selected, non-failure
    /// item across every level (i.e. every item successfully picked before either finishing or
    /// hitting a failure) — a level failed on doesn't retroactively lose already-collected
    /// levels' chips.
    func chipsWon(selectedBetChips: Double) -> Double {
        var payoutSum = 0.0
        for level in levels {
            for item in level.items where item.isSelected && !item.isFailure {
                payoutSum += Double(item.payout)
            }
        }
        return payoutSum * selectedBetChips
    }
}
