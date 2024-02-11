//
//  Game.swift
//  BowlingGame
//
//  Created by Julia Ajhar on 2/8/24.
//

import Foundation

protocol GameProtocol {
    var players: [(any PlayerProtocol)] { get }
    var currentPlayer: (any PlayerProtocol) { get }
    var currentFrameNumber: Int { get }
    var currentFrame: ScoreFrame { get }
    var scoreCards: [ScoreCard] { get }
    var isEndOfGame: Bool { get }
    
    func score(for player: (any PlayerProtocol)?) -> Int
    func roll(pinsKnocked: Int) -> Bool
    func reset()
}

final class Game: GameProtocol {
    struct Constants {
        static let defaultPlayer = Player(name: "Player 1")
    }
    
    /// List of players for the game
    let players: [(any PlayerProtocol)]
    
    /// The current player up to bowl
    private(set) var currentPlayer: any PlayerProtocol = Constants.defaultPlayer
    
    /// Index of the current player
    private var currentPlayerIndex: Int = 0

    /// The index of the current frame relative to the current player
    private(set) var currentFrameNumber: Int = 0
        
    /// key = user id, value = scores for specific user
    private var scores = [String: ScoreManager]()
    
    /// The current frame being bowled
    var currentFrame: ScoreFrame {
        scoreManager(forPlayer: currentPlayer).currentFrame
    }
    
    /// True if every player has taken their last turn
    var isEndOfGame: Bool {
        for player in players {
            if scores[player.id]?.isGameFinished == false {
                return false
            }
        }
        return true
    }
    
    /// General model representing a user's active frames and score
    var scoreCards: [ScoreCard] {
        players.map {
            ScoreCard(
                player: $0,
                frames: scoreManager(forPlayer: $0).frames,
                score: score(for: $0)
            )
        }
    }

    init(players: [any PlayerProtocol]) {
        self.players = players.isEmpty ? [Constants.defaultPlayer] : players
        resetPlayerOrder()
        
        self.players.forEach {
            scores[$0.id] = ScoreManager()
        }
    }
    
    /// Returns the score for a given player
    /// - Parameter player: The player to fetch the score for
    /// - Returns: The score for the given player
    func score(for player: (any PlayerProtocol)?) -> Int {
        let player = player ?? currentPlayer
        return scoreManager(forPlayer: player).score
    }
    
    /// Call to add a roll to the current player's game
    /// - Parameter pinsKnocked: The number of pins knocked down on this roll
    /// - Returns: True if the roll was valid and added successfully
    @discardableResult
    func roll(pinsKnocked: Int) -> Bool {
        let manager = scoreManager(forPlayer: currentPlayer)
        
        guard manager.roll(pinsKnocked) else { return false }
        
        if manager.currentFrameNumber != currentFrameNumber || manager.isGameFinished {
            // frame changed, move to next player if applicable
            changeToNextPlayer()
        }
        
        return true
    }
    
    /// Call to switch to the next available player (round robin style)
    private func changeToNextPlayer() {
        if currentPlayerIndex + 1 >= players.count {
            currentPlayerIndex = 0
        } else {
            currentPlayerIndex += 1
        }
        
        currentPlayer = players[currentPlayerIndex]
        let manager = scoreManager(forPlayer: currentPlayer)
        currentFrameNumber = manager.currentFrameNumber
    }
    
    /// Call to reset the game back to its original state
    func reset() {
        players.forEach {
            self.scores[$0.id]?.reset()
        }
        
        resetPlayerOrder()
        
        let manager = scoreManager(forPlayer: currentPlayer)
        currentFrameNumber = manager.currentFrameNumber
    }
    
    /// Call to reset the current player to the first player
    private func resetPlayerOrder() {
        guard let player = players.first else { return }
        // Player 1 always starts then it's a round robin experience
        currentPlayer = player
    }
    
    /// Call to fetch the `ScoreManager` for a given player
    /// - Parameter player: The player
    /// - Returns: The `ScoreManager` for the given player
    private func scoreManager(forPlayer player: (any PlayerProtocol)) -> ScoreManager {
        guard let manager = scores[player.id] else {
            assertionFailure("Player \(player.name) is missing associated ScoreManager.")
            return ScoreManager()
        }
        return manager
    }
}
