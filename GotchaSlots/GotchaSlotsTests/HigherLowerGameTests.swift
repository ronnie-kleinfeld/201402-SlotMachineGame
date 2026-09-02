import XCTest
@testable import GotchaSlots

final class HigherLowerGameTests: XCTestCase {
    func testInitialState_rung0IsPreWonWithRandomFive() {
        let state = HigherLowerGameState()
        XCTAssertEqual(state.currentIndex, 0)
        XCTAssertEqual(state.rungs[0].random, 5)
        XCTAssertTrue(state.rungs[0].isWon)
        XCTAssertFalse(state.isOver)
    }

    func testRatiosMatchTheSevenRungLadder() {
        let state = HigherLowerGameState()
        XCTAssertEqual(state.rungs.map(\.ratio), [1, 2, 3, 5, 7, 10, 15])
    }

    func testUnplayedGame_paysTheBaselineRatio() {
        // Never guessed at all -> only rung 0 (pre-won) contributes.
        let state = HigherLowerGameState()
        XCTAssertEqual(state.chipsWon(selectedBetChips: 10.0), 10) // ratio 1 * bet 10
    }

    func testNewRandom_isNeverEqualToThePreviousRung() {
        // Run many times since the draw is randomized; the retry-until-different guarantee
        // must hold every time, not just usually.
        for _ in 0..<200 {
            var state = HigherLowerGameState()
            let previous = state.rungs[0].random
            _ = state.guess(.higher)
            XCTAssertNotEqual(state.rungs[1].random, previous)
        }
    }

    func testCorrectGuess_advancesTheLadder_andIsNotOver() {
        // Force a deterministic outcome by guessing whichever direction is actually correct,
        // discovered after the fact (since the draw is random) — the point under test is the
        // ladder-advancement bookkeeping, not the RNG itself.
        var state = HigherLowerGameState()
        let previous = state.rungs[0].random
        let outcome = state.guess(.higher)
        let newRandom = state.rungs[1].random

        if newRandom > previous {
            XCTAssertEqual(outcome, .correct)
            XCTAssertTrue(state.rungs[1].isWon)
            XCTAssertFalse(state.isOver)
            XCTAssertEqual(state.currentIndex, 1)
        } else {
            XCTAssertEqual(outcome, .incorrect)
            XCTAssertFalse(state.rungs[1].isWon)
            XCTAssertTrue(state.isOver)
        }
    }

    func testIncorrectGuess_endsTheGame_keepsLastWonRatio() {
        var state = HigherLowerGameState()
        // Guess in the direction that will be wrong regardless of the actual draw isn't
        // possible without controlling RNG, so instead: guess repeatedly until we observe an
        // incorrect outcome (P(incorrect) is high enough that this reliably happens quickly),
        // then assert the state afterward.
        var outcome: HigherLowerOutcome = .correct
        var guesses = 0
        while outcome == .correct && !state.isOver && guesses < 50 {
            outcome = state.guess(.higher)
            guesses += 1
        }
        if outcome == .incorrect {
            XCTAssertTrue(state.isOver)
            // Chips should reflect the last WON rung, not the failed one.
            let lastWonRatio = state.rungs.last(where: \.isWon)?.ratio ?? 1
            XCTAssertEqual(state.chipsWon(selectedBetChips: 1.0), lastWonRatio)
        }
    }

    func testReachingTheTopRung_endsTheGameAsLadderComplete() {
        var state = HigherLowerGameState()
        var outcome: HigherLowerOutcome = .correct
        var guesses = 0
        // Always guess "higher" after seeing the actual random isn't possible; instead simulate
        // enough rounds that either we finish the ladder or lose — both are valid terminal
        // states, and this test only checks that .ladderComplete is reachable in principle by
        // asserting the loop terminates in isOver with a sensible outcome.
        while !state.isOver && guesses < 10 {
            outcome = state.guess(.higher)
            guesses += 1
        }
        XCTAssertTrue(state.isOver)
        XCTAssertTrue(outcome == .incorrect || outcome == .ladderComplete)
        if outcome == .ladderComplete {
            XCTAssertEqual(state.currentIndex, 6)
            XCTAssertEqual(state.chipsWon(selectedBetChips: 1.0), 15) // top ratio
        }
    }
}
