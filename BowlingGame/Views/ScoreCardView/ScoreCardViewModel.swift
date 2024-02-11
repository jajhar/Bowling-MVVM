//
//  ScoreCardViewModel.swift
//  BowlingGame
//
//  Created by Julia Ajhar on 2/8/24.
//

import SwiftUI
import Foundation

protocol ScoreCardViewModelProtocol {
    var currentPlayer: any PlayerProtocol { get }
    var score: Int { get }
    var error: ScoreCardViewModelError? { get }
    var scoreCards: [ScoreCard] { get }
    var currentFrameNumber: Int { get }
    var currentFrame: ScoreFrame { get }
    var isEndOfGame: Bool { get }

    func roll(pinsKnocked: Int) -> Bool
    func resetGame()
}

enum ScoreCardViewModelError: Error {
    case invalidPinEntry
    
    var message: String {
        switch self {
        case .invalidPinEntry:
            return "Invalid pin entry. Please enter a valid number."
        }
    }
}

class ScoreCardViewModel: ObservableObject, ScoreCardViewModelProtocol {
    private(set) var game: GameProtocol
    
    @Published var currentPlayer: any PlayerProtocol
    @Published var score: Int = 0
    @Published var scoreCards = [ScoreCard]()
    @Published var currentFrameNumber: Int = 0
    @Published var currentFrame: ScoreFrame
    @Published var error: ScoreCardViewModelError?
    @Published var isEndOfGame: Bool

    var startingFrameIds: [String] {
        game.scoreCards.compactMap {
            $0.frames.first?.id
        }
    }
    
    init(game: GameProtocol) {
        self.game = game
        self.currentPlayer = game.currentPlayer
        self.currentFrame = game.currentFrame
        self.isEndOfGame = game.isEndOfGame
        updateData()
    }
    
    @discardableResult
    func roll(pinsKnocked: Int) -> Bool {
        guard game.roll(pinsKnocked: pinsKnocked) else {
            error = .invalidPinEntry
            return false
        }
        error = nil
        updateData()
        return true
    }
    
    func resetGame() {
        error = nil
        game.reset()
        updateData()
    }
    
    private func updateData() {
        currentPlayer = game.currentPlayer
        score = game.score(for: currentPlayer)
        currentFrameNumber = game.currentFrameNumber
        currentFrame = game.currentFrame
        scoreCards = game.scoreCards
        isEndOfGame = game.isEndOfGame
    }
}
