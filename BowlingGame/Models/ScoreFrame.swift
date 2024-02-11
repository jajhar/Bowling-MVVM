//
//  ScoreFrame.swift
//  BowlingGame
//
//  Created by Julia Ajhar on 2/8/24.
//

import Foundation

/// An object representing a single frame in a game
final class ScoreFrame {
    struct Constants {
        static let defaultPinsLeft = 10
        static let defaultScore = 0
    }
    
    let id = UUID().uuidString
    
    private(set) var score: Int
    private(set) var rolls = [Int]()
    
    var pinsLeft: Int {
        max(Constants.defaultPinsLeft - rolls.reduce(0, { $0 + $1 }), 0)
    }
    
    init(score: Int = Constants.defaultScore, rolls: [Int] = [Int]()) {
        self.score = score
        self.rolls = rolls
    }
    
    func updateScore(_ score: Int) {
        self.score = score
    }

    func addRoll(_ roll: Int) {
        rolls.append(roll)
    }
    
    func reset() {
        score = Constants.defaultScore
        rolls.removeAll()
    }
}
