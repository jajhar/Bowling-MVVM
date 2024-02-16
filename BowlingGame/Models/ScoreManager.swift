//
//  ScoreManager.swift
//  BowlingGame
//
//  Created by Julia Ajhar on 2/8/24.
//

import Foundation

protocol ScoreManagerProtocol {
    var currentFrameNumber: Int { get }
    var currentFrame: ScoreFrame { get }
    var isLastFrame: Bool { get }
    var isGameFinished: Bool { get }
    var frames: [ScoreFrame] { get }
    var score: Int { get }
    
    func roll(_ pinsKnocked: Int) -> Bool
    func reset()
}

/// An object for managing the scoring mechanics for a game
final class ScoreManager: ScoreManagerProtocol {
    /// running list of all possible rolls in a game (updated dynamically)
    private var rolls = [Int](repeating: 0, count: 21) // 21 possible throws in a game
    
    /// Total rolls thrown by this player
    private(set) var currentTotalRolls: Int = 0
    
    /// All available frames for this game
    private(set) var frames = [ScoreFrame]()
    
    /// Current score
    private(set) var score: Int = 0
    
    /// Current frame index
    private(set) var currentFrameNumber: Int = 0
    
    /// The current frame for this player's game
    var currentFrame: ScoreFrame {
        frames[currentFrameNumber]
    }
    
    /// True if this player is on their last frame
    var isLastFrame: Bool {
        currentFrameNumber == 9
    }
    
    // true when there are no possible rolls left to make
    var isGameFinished: Bool {
        guard isLastFrame else {
            return false
        }
        
        let frame = currentFrame
        
        if frame.rolls.isEmpty {
            // no rolls taken yet
            return false
        } else if frame.rolls.first == 10, frame.rolls.count < 3 {
            // if first roll is a strike, player can roll again if frame has pins left (excluding the strike)
            return false
        } else if frame.rolls.count == 1, frame.rolls[0] != 10  {
            // if first roll is not a strike, player can roll if there are pins left in the frame.
            return false
        } else if frame.rolls.count == 2,
                  frame.rolls[0] + frame.rolls[1] == 10 || frame.rolls[1] == 10
        {
            // if the second roll is a strike or a spare, that means we have one bonus throw.
            return false
        }
        
        return true
    }
    
    init() {
        for _ in 0..<10 {
            // 10 frames in a game
            frames.append(ScoreFrame())
        }
    }
    
    /// Call to add a roll to the current player's game
    /// - Parameter pinsKnocked: The number of pins knocked down on this roll
    /// - Returns: True if the roll was valid and added successfully
    @discardableResult
    func roll(_ pinsKnocked: Int) -> Bool {
        guard validateRoll(pinsKnocked) else { return false}
        rolls.insert(pinsKnocked, at: currentTotalRolls)
        frames[currentFrameNumber].addRoll(pinsKnocked)
        currentTotalRolls += 1
        recalculateFrames()
        return true
    }
    
    /// Call to reset the manager to its original state
    func reset() {
        rolls = [Int](repeating: 0, count: 21)
        currentTotalRolls = 0
        frames.forEach { $0.reset() }
        recalculateFrames()
    }
    
    /// Call to validate if a given roll value is possible for the current frame
    /// - Parameter roll: The number of pins knocked down on this roll
    /// - Returns: True if the roll is valid for this frame
    private func validateRoll(_ roll: Int) -> Bool {
        guard roll <= 10 && roll >= 0 else { return false }

        if isLastFrame {
            let frame = currentFrame
            
            if frame.rolls.first == 10, frame.rolls.count < 3 {
                // if first roll is a strike, player can roll again if frame has pins left (excluding the strike)
                return roll <= frame.pinsLeft + 10
            } else if frame.rolls.count == 1, frame.rolls[0] != 10  {
                // if first roll is not a strike, player can roll if there are pins left in the frame.
                return roll <= frame.pinsLeft
            } else if frame.rolls.count == 2,
                      frame.rolls[0] + frame.rolls[1] == 10 || frame.rolls[1] == 10
            {
                // if the second roll is a strike or a spare, that means we have one bonus throw.
                return true
            }
        }
        
        return roll <= currentFrame.pinsLeft
    }
    
    /// Call to recalculate the scores for each frame, as well as the total score.
    private func recalculateFrames() {
        score = 0
        var roll = 0
        var curFrameIndex: Int? // index of the most recent frame
        
        for frameIndex in 0..<frames.count {            
            if isStrike(roll) {
                score += 10 + strikeBonus(roll)
                roll += 1
            } else if isSpare(roll) {
                score += 10 + spareBonus(roll)
                roll += 2
            } else {
                // check the next two rolls ie "frame"
                score += scoreForFrame(roll)
                roll += 2
            }
            
            if roll <= currentTotalRolls {
                // if roll is 
                frames[frameIndex].updateScore(score)
            }
            
            if roll >= currentTotalRolls+1, curFrameIndex == nil {
                curFrameIndex = frameIndex
            }
        }
        
        currentFrameNumber = curFrameIndex ?? currentFrameNumber
    }
    
    private func isStrike(_ roll: Int) -> Bool {
        rolls[roll] == 10
    }
    
    private func isSpare(_ roll: Int) -> Bool {
        rolls[roll] + rolls[roll + 1] == 10
    }
    
    private func strikeBonus(_ roll: Int) -> Int {
        rolls[roll + 1] + rolls[roll + 2]
    }
    
    private func spareBonus(_ roll: Int) -> Int {
        rolls[roll + 2]
    }
    
    private func scoreForFrame(_ roll: Int) -> Int {
        rolls[roll] + rolls[roll + 1]
    }
}
