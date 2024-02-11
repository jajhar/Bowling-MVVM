//
//  MockDataFactory.swift
//  BowlingGameTests
//
//  Created by Julia Ajhar on 2/8/24.
//

import XCTest
@testable import BowlingGame
import SwiftUI

struct MockDataFactory {
    
    static func makeMockGame(
        players: [any PlayerProtocol] = [MockDataFactory.makeMockPlayer()],
        isEndOfGame: Bool = false
    ) -> MockGame {
        MockGame(
            players: players,
            isEndOfGame: false
        )
    }
    
    static func makeMockPlayer(
        id: String = "player_id",
        name: String = "player_name"
    ) -> MockPlayer {
        MockPlayer(id: id, name: name)
    }
    
    static func makeScoreCard(
        player: any PlayerProtocol,
        frames: [ScoreFrame] = [],
        score: Int = 0
    ) -> ScoreCard {
        .init(player: player, frames: frames, score: score)
    }
    
    static func makeMockCoordinatorPathHandler() -> MockCoordinatorPathHandler {
        .init()
    }
}

class MockPlayer: PlayerProtocol {
    var id: String
    var name: String
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}

class MockGame: GameProtocol {
    var players: [(any PlayerProtocol)] = []
    var currentPlayer: (any PlayerProtocol) = Player(name: "test_user")
    var currentFrameNumber: Int = 0
    var currentFrame: ScoreFrame = .init()
    var scoreCards: [ScoreCard] = []
    var isEndOfGame: Bool = false

    // Testable Properties
    var mockScore: Int = 0
    var pinsLeft: Int = .max
    
    init(players: [any PlayerProtocol], isEndOfGame: Bool) {
        self.players = players
        self.currentPlayer = players.first ?? currentPlayer
        self.isEndOfGame = isEndOfGame
    }
    
    // Test Values
    private(set) var didCallRollCount = 0
    private(set) var didCallResetCount = 0
    private(set) var didCallScoreCount = 0

    func score(for player: (any PlayerProtocol)?) -> Int {
        didCallScoreCount += 1
        return mockScore
    }
    
    @discardableResult
    func roll(pinsKnocked: Int) -> Bool {
        didCallRollCount += 1
        if pinsKnocked <= pinsLeft {
            pinsLeft -= pinsKnocked
            return true
        }
        return false
    }
    
    func reset() {
        didCallResetCount += 1
    }
}

class MockCoordinatorPathHandler: CoordinatorPathHandlerProtocol {
    private(set) var pushCallCount = 0
    private(set) var popCallCount = 0
    private(set) var popToRootCallCount = 0

    func push(_ page: BowlingGame.Page, path: inout NavigationPath) {
        pushCallCount += 1
    }
    
    func pop(path: inout NavigationPath) {
        popCallCount += 1
    }
    
    func popToRoot(path: inout NavigationPath) {
        popToRootCallCount += 1
    }
}
