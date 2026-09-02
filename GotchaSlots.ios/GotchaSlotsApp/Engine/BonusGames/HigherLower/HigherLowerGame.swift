import Foundation

/// Ports HigherLowerPayoutData: one rung of the ladder.
struct HigherLowerRung {
    let id: Int
    let ratio: Double
    var random: Int
    var isWon: Bool
}

enum HigherLowerGuess {
    case higher
    case lower
}

enum HigherLowerOutcome: Equatable {
    case correct
    case incorrect
    case ladderComplete
}

/// Ports HigherLowerData + SpinnerPanel.DoSpin: a 7-rung double-or-nothing ladder. Rung 0 starts
/// pre-won (Random=5, IsWon=true — ports the exact literal init in HigherLowerData's
/// constructor), so a player who never guesses still walks away with the 1x baseline. Guessing
/// correctly advances up the ladder toward higher payout ratios; one wrong guess ends the game,
/// keeping whatever rung was last actually won.
struct HigherLowerGameState {
    private(set) var rungs: [HigherLowerRung]
    private(set) var currentIndex: Int = 0
    private(set) var isOver: Bool = false

    /// Ports `_higherLowerPayouts.push(new HigherLowerPayoutData(id, ratio))` for ratios
    /// [1, 2, 3, 5, 7, 10, 15], then the literal `_higherLowerPayouts[0].Random = 5;
    /// _higherLowerPayouts[0].IsWon = true;`.
    init() {
        let ratios: [Double] = [1, 2, 3, 5, 7, 10, 15]
        rungs = ratios.enumerated().map { HigherLowerRung(id: $0, ratio: $1, random: 0, isWon: false) }
        rungs[0].random = 5
        rungs[0].isWon = true
    }

    var currentRung: HigherLowerRung { rungs[currentIndex] }

    /// Ports SpinnerPanel.DoSpin + HigherLowerEngine.onSpinnerPanelComplete: draws a new
    /// 1...9 value guaranteed different from the previous rung's, compares it against the
    /// guess, advances the ladder on a correct guess (or ends the game at the top rung), and
    /// ends the game immediately on an incorrect guess.
    mutating func guess(_ guess: HigherLowerGuess) -> HigherLowerOutcome {
        guard !isOver, currentIndex < rungs.count - 1 else {
            isOver = true
            return .ladderComplete
        }

        let previousRandom = rungs[currentIndex].random
        currentIndex += 1

        var newRandom: Int
        repeat {
            newRandom = Int(ceil(Double.random(in: 0..<1) * 9))
        } while newRandom == previousRandom
        rungs[currentIndex].random = newRandom

        let isCorrect = (guess == .higher && newRandom > previousRandom) || (guess == .lower && newRandom < previousRandom)
        rungs[currentIndex].isWon = isCorrect

        guard isCorrect else {
            isOver = true
            return .incorrect
        }

        if currentIndex >= rungs.count - 1 {
            isOver = true
            return .ladderComplete
        }
        return .correct
    }

    /// Ports HigherLowerData.CalculateChipsWon: scans forward and keeps overwriting with each
    /// won rung's ratio, so the LAST (highest-index) won rung determines the payout.
    func chipsWon(selectedBetChips: Double) -> Double {
        var chips = 0.0
        for rung in rungs where rung.isWon {
            chips = selectedBetChips * rung.ratio
        }
        return chips
    }
}
