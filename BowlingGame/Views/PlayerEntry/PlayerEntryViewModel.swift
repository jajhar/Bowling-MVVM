//
//  PlayerEntryViewModel.swift
//  BowlingGame
//
//  Created by Julia Ajhar on 2/16/24.
//

import Foundation
import SwiftUI

protocol PlayerEntryViewModelProtocol {
    var players: [PlayerProtocol] { get }
    
    func addPlayer(withName name: String)
}

class PlayerEntryViewModel: PlayerEntryViewModelProtocol, ObservableObject {
    @Published var players: [PlayerProtocol]
    
    private let maxPlayers: Int
    
    @Published var canBowl: Bool = false

    init(
        players: [PlayerProtocol] = [],
        maxPlayers: Int = 4
    ) {
        self.players = players
        self.maxPlayers = maxPlayers
    }
    
    func addPlayer(withName name: String) {
        guard players.count < maxPlayers else {
            return
        }
        players.append(Player(name: name))
        canBowl = true
    }
}
