//
//  ScoreCardViewModelTests.swift
//  BowlingGameTests
//
//  Created by Julia Ajhar on 2/9/24.
//

import Foundation
import XCTest
@testable import BowlingGame

final class ScoreCardViewModelTests: XCTestCase {
    func makeSUT(
        game: GameProtocol = MockDataFactory.makeMockGame()
    ) -> ScoreCardViewModel {
        .init(game: game)
    }
    
    func test_rolls_doesCallGameRoll() {
        let game = MockDataFactory.makeMockGame()
        let sut = makeSUT(game: game)
        
        sut.roll(pinsKnocked: 3)
        XCTAssertEqual(game.didCallRollCount, 1)
        
        sut.roll(pinsKnocked: 2)
        XCTAssertEqual(game.didCallRollCount, 2)
    }
    
    func test_rolls_updatesData() {
        let mockPlayer1 = MockDataFactory.makeMockPlayer()
        let mockPlayer2 = MockDataFactory.makeMockPlayer()
        let game = MockDataFactory.makeMockGame(players: [mockPlayer1, mockPlayer2])
        let sut = makeSUT(game: game)

        XCTAssertEqual(sut.currentPlayer.id, mockPlayer1.id)
        XCTAssertEqual(sut.score, game.score(for: mockPlayer1))
        XCTAssertEqual(sut.currentFrameNumber, game.currentFrameNumber)
                
        // simulate changes on the game
        game.mockScore = 3
        game.currentFrameNumber = 1
        game.currentPlayer = mockPlayer2
        
        // initiate a roll
        sut.roll(pinsKnocked: 10)
        
        // Assert the view model upates data based on the game
        XCTAssertEqual(sut.currentPlayer.id, mockPlayer2.id)
        XCTAssertEqual(sut.score, game.score(for: mockPlayer2))
        XCTAssertEqual(sut.currentFrameNumber, game.currentFrameNumber)
    }
    
    func test_reset_callsGameReset() {
        let game = MockDataFactory.makeMockGame()
        let sut = makeSUT(game: game)
        
        sut.resetGame()
        XCTAssertEqual(game.didCallResetCount, 1)
    }
    
    func test_reset_resetsGame() {
        let game = MockDataFactory.makeMockGame()
        let sut = makeSUT(game: game)
        
        sut.resetGame()
        XCTAssertEqual(game.didCallResetCount, 1)
    }
    
    func test_rolls_invalidRollPopulatesError() {
        let game = MockDataFactory.makeMockGame()
        let sut = makeSUT(game: game)
        
        game.pinsLeft = 10 // force pins to 10
        sut.roll(pinsKnocked: 7)
        
        XCTAssertFalse(sut.roll(pinsKnocked: 7)) // only 3 pins left
        XCTAssertNotNil(sut.error) // error should be populated
        
        sut.roll(pinsKnocked: 3) // make a valid roll
        XCTAssertNil(sut.error) // error should be gone
    }
}
