//
//  ScoreFrameViewModelTests.swift
//  BowlingGameTests
//
//  Created by Julia Ajhar on 2/9/24.
//

import Foundation
import XCTest
@testable import BowlingGame

final class ScoreFrameViewModelTests: XCTestCase {
    func makeSUT(
        scoreFrame: ScoreFrame,
        frameCount: Int = 1,
        isActive: Bool = false
    ) -> ScoreFrameViewModel {
        .init(scoreFrame: scoreFrame, frameCount: frameCount, isActive: isActive)
    }
    
    func test_rollText_nonStrikeOrSpare() {
        let frame = ScoreFrame(score: 3, rolls: [1, 2])
        let sut = makeSUT(scoreFrame: frame)
        XCTAssertEqual(sut.rollText, "[1][2]")
    }
    
    func test_rollText_strike() {
        let frame = ScoreFrame(score: 10, rolls: [10])
        let sut = makeSUT(scoreFrame: frame)
        XCTAssertEqual(sut.rollText, "[X]")
    }

    func test_rollText_spare() {
        let frame = ScoreFrame(score: 10, rolls: [8, 2])
        let sut = makeSUT(scoreFrame: frame)
        XCTAssertEqual(sut.rollText, "[8][/]")
    }
}
