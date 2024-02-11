//
//  ScoreManagerTests.swift
//  BowlingGameTests
//
//  Created by Julia Ajhar on 2/8/24.
//

import Foundation
import XCTest
@testable import BowlingGame

final class ScoreManagerTests: XCTestCase {
    func makeSUT() -> ScoreManager {
        ScoreManager()
    }
    
    func test_rolls_validation_cantRollIfInsufficientPins () {
        let sut = makeSUT()
        
        let frame = sut.currentFrame
        XCTAssertEqual(frame.pinsLeft, 10)
        XCTAssertTrue(sut.roll(6))
        XCTAssertFalse(sut.roll(6)) // false - only 4 pins left
    }
    
    func test_rolls_frameUpdatesAfterRoll() {
        let sut = makeSUT()
        
        let frame = sut.currentFrame
        let frameNumer = sut.currentFrameNumber
        
        XCTAssertEqual(frame.pinsLeft, 10)
            
        sut.roll(6)
        XCTAssertEqual(frame.pinsLeft, 4)
        XCTAssertEqual(frame.rolls, [6])

        sut.roll(2)
        XCTAssertEqual(frame.pinsLeft, 2)
        XCTAssertEqual(frame.rolls, [6, 2])
        XCTAssertEqual(frame.score, 8)
        XCTAssertEqual(sut.currentFrameNumber, frameNumer + 1)
    }
    
    func test_rolls_lastFrameUpdates() {
        let sut = makeSUT()

        XCTAssertFalse(sut.isLastFrame)

        sut.rollMany(pins: 10, times: 10)
        XCTAssertTrue(sut.isLastFrame)
    }
    
    func test_rolls_gameFinishes() {
        let sut = makeSUT()

        XCTAssertFalse(sut.isGameFinished)

        sut.rollMany(pins: 10, times: 12)
        XCTAssertTrue(sut.isGameFinished)
    }
    
    func test_rolls_scoreUpdates() {
        let sut = makeSUT()

        XCTAssertEqual(sut.score, 0)
        
        sut.rollStrike()
        XCTAssertEqual(sut.score, 10)

        sut.rollStrike()
        XCTAssertEqual(sut.score, 30)
        
        sut.rollSpare()
        XCTAssertEqual(sut.score, 55)
        
        sut.roll(2)
        XCTAssertEqual(sut.score, 59)
    }
    
    func test_reset_scoreDataResets() {
        let sut = makeSUT()
        
        // start with a game in progress
        sut.rollMany(pins: 10, times: 10)
        
        // reset
        sut.reset()
        
        // assert data resets
        XCTAssertEqual(sut.currentTotalRolls, 0)
        XCTAssertEqual(sut.currentFrameNumber, 0)
        XCTAssertEqual(sut.score, 0)
        
        for frame in sut.frames {
            XCTAssertEqual(frame.score, 0)
        }
    }
}

private extension ScoreManager {
    func rollMany(pins: Int, times: Int) {
        for _ in 1...times {
            roll(pins)
        }
    }
    func rollSpare() {
        roll(5)
        roll(5)
    }
    
    func rollStrike() {
        roll(10)
    }
}
