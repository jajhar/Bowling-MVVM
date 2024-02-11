//
//  ScoreFrameViewModel.swift
//  BowlingGame
//
//  Created by Julia Ajhar on 2/8/24.
//

import Foundation

protocol ScoreFrameViewModelProtocol {
    var scoreFrame: ScoreFrame { get }
    var frameCount: Int { get }
}

class ScoreFrameViewModel: ObservableObject, ScoreFrameViewModelProtocol {
    let scoreFrame: ScoreFrame
    
    @Published private(set) var frameCount: Int
    @Published private(set) var rolls: [Int]
    @Published private(set) var score: Int = 0
    @Published private(set) var isActive: Bool
    
    private func isStrike(_ roll: Int) -> Bool  {
        rolls[roll] == 10
    }
    
    private func isSpare(_ roll: Int) -> Bool {
        guard roll + 1 < rolls.count else { return false }
        return rolls[roll] + rolls[roll + 1] == 10
    }
    
    /// The text representing the rolls for this frame based on bowling score mechanics
    var rollText: String {
        var result = ""
        var roll = 0
        
        while roll < rolls.count {
            if isStrike(roll) {
                result += "[X]"
                roll += 1
            } else if isSpare(roll) {
                result += "[\(rolls[roll])][/]"
                roll += 2
            } else if !rolls.isEmpty {
                result += "[\(rolls[roll] == 0 ? "-" : "\(rolls[roll])")]"
                roll += 1
            }
        }
        
        return result
    }
    
    init(
        scoreFrame: ScoreFrame,
        frameCount: Int,
        isActive: Bool
    ) {
        self.scoreFrame = scoreFrame
        self.frameCount = frameCount
        self.isActive = isActive
        self.rolls = scoreFrame.rolls
        self.score = scoreFrame.score
    }
}
