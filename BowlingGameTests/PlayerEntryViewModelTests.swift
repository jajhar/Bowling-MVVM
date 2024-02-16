//
//  PlayerEntryViewModelTests.swift
//  BowlingGameTests
//
//  Created by Julia Ajhar on 2/16/24.
//

import XCTest
@testable import BowlingGame

final class PlayerEntryViewModelTests: XCTestCase {

    func makeSUT(
        players: [(any PlayerProtocol)] = [],
        maxPlayers: Int = 1
    ) -> PlayerEntryViewModel {
        PlayerEntryViewModel(
            players: players,
            maxPlayers: maxPlayers
        )
    }
    
    func test_addPlayer_isAddedToPlayersList() {
        let sut = makeSUT()
    
        XCTAssertEqual(sut.players.count, 0)
        
        // When
        sut.addPlayer(withName: "Julia")
        
        XCTAssertEqual(sut.players.count, 1)
        XCTAssertEqual(sut.players.first?.name, "Julia")
    }
    
    func test_addPlayer_atMax_cannotAddNewPlayer() {
        let sut = makeSUT(maxPlayers: 1)

        // When
        sut.addPlayer(withName: "Player 1")
        // When
        sut.addPlayer(withName: "Player 2")

        XCTAssertEqual(sut.players.count, 1)
        XCTAssertEqual(sut.players.first?.name, "Player 1")
    }
}
