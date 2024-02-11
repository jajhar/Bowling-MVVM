//
//  Player.swift
//  BowlingGame
//
//  Created by Julia Ajhar on 2/8/24.
//

import Foundation

protocol PlayerProtocol {
    var id: String { get }
    var name: String { get }
}

class Player: PlayerProtocol {
    let id = UUID().uuidString
    let name: String
    
    init(name: String) {
        self.name = name
    }
}
