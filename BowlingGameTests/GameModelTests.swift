//
//  GameModelTests.swift
//  BowlingGameTests
//
//  Created by Julia Ajhar on 2/8/24.
//

import XCTest
@testable import BowlingGame

final class GameModelTests: XCTestCase {
    func makeSUT(
        players: [(any PlayerProtocol)] = [MockDataFactory.makeMockPlayer()]
    ) -> Game {
        Game(players: players)
    }
    
    func test_rolls_spare() {
        let player = MockDataFactory.makeMockPlayer()
        let sut = makeSUT(
            players: [player]
        )
        
        sut.rollSpare()
        sut.roll(pinsKnocked: 3)
        sut.rollMany(pins: 0, times: 17)
        XCTAssertEqual(sut.score(for: player), 16)
    }
    
    func test_rolls_strike() {
        let player = MockDataFactory.makeMockPlayer()
        let sut = makeSUT(
            players: [player]
        )
        
        sut.rollStrike()
        sut.roll(pinsKnocked: 3)
        sut.roll(pinsKnocked: 4)
        sut.rollMany(pins: 0, times: 16)
        XCTAssertEqual(sut.score(for: player), 24)
    }
    
    func test_rolls_perfectGame() {
        let player = MockDataFactory.makeMockPlayer()
        let sut = makeSUT(
            players: [player]
        )
        
        sut.rollMany(pins: 10, times: 12)
        XCTAssertEqual(sut.score(for: player), 300)
    }
    
    func test_rolls_cantRollPastMaxScore() {
        let player = MockDataFactory.makeMockPlayer()
        let sut = makeSUT(
            players: [player]
        )
        
        sut.rollMany(pins: 10, times: 15)
        XCTAssertEqual(sut.score(for: player), 300)
    }
    
    func test_rolls_cantRollIfGreaterThanPinsLeft() {
        let player = MockDataFactory.makeMockPlayer()
        let sut = makeSUT(
            players: [player]
        )

        sut.roll(pinsKnocked: 6)
        XCTAssertFalse(sut.roll(pinsKnocked: 5)) // only 4 pins left
        XCTAssertEqual(sut.score(for: player), 6) // score should not update (invalid roll)
    }
    
    func test_rolls_frameUpdatesAfterEachRoll() {
        let sut = makeSUT()
        let frame = sut.currentFrame
        XCTAssertEqual(frame.pinsLeft, 10)
            
        sut.roll(pinsKnocked: 6)
        XCTAssertEqual(frame.pinsLeft, 4)
        XCTAssertEqual(frame.rolls, [6])

        sut.roll(pinsKnocked: 2)
        XCTAssertEqual(frame.pinsLeft, 2)
        XCTAssertEqual(frame.rolls, [6, 2])
        XCTAssertEqual(frame.score, 8)
    }
    
    func test_rolls_multiplayer_playerChangeOccursAfterFrameCompletion() {
        let player1 = MockDataFactory.makeMockPlayer(id: "player1")
        let player2 = MockDataFactory.makeMockPlayer(id: "player2")
        let sut = makeSUT(players: [player1, player2])
        
        // player 1 up first
        XCTAssertEqual(sut.currentPlayer.id, player1.id)

        // player one finishes their frame
        sut.rollStrike()

        // player 2 up next
        XCTAssertEqual(sut.currentPlayer.id, player2.id)
        XCTAssertEqual(sut.currentFrameNumber, 0) // frame is 0 for player 2
        
        // player two finishes their frame
        sut.rollStrike()

        // player 1 up next
        XCTAssertEqual(sut.currentPlayer.id, player1.id)
    }
    
    func test_rolls_singlePlayer_endOfGameFlagReached() {
        let sut = makeSUT()
        sut.rollStrike()
        XCTAssertFalse(sut.isEndOfGame)
        sut.rollMany(pins: 10, times: 23)
        XCTAssertTrue(sut.isEndOfGame)
    }
    
    func test_rolls_multiplayer_endOfGameFlagReached() {
        let sut = makeSUT()
        
        sut.rollStrike()
        XCTAssertFalse(sut.isEndOfGame)
        
        // player one and two both finish their game
        sut.rollMany(pins: 10, times: 23)
        XCTAssertTrue(sut.isEndOfGame)
    }
    
    func test_reset_gameDataResets() {
        let player1 = MockDataFactory.makeMockPlayer(id: "player1")
        let player2 = MockDataFactory.makeMockPlayer(id: "player2")
        let sut = makeSUT(players: [player1, player2])
        
        // start with a game in progress
        sut.rollMany(pins: 10, times: 11)
        
        // call reset
        sut.reset()
        // assert data returns to default state
        XCTAssertEqual(sut.currentFrameNumber, 0)
        XCTAssertEqual(sut.currentPlayer.id, player1.id)
        XCTAssertEqual(sut.score(for: player1), 0)
        XCTAssertEqual(sut.score(for: player2), 0)
    }
}

private extension Game {
    func rollMany(pins: Int, times: Int) {
        for _ in 1...times {
            roll(pinsKnocked: pins)
        }
    }
    func rollSpare() {
        roll(pinsKnocked: 5)
        roll(pinsKnocked: 5)
    }
    
    func rollStrike() {
        roll(pinsKnocked: 10)
    }
}
