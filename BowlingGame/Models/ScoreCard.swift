//
//  ScoreCard.swift
//  BowlingGame
//
//  Created by Julia Ajhar on 2/8/24.
//

import Foundation

/// An object representing a single player's game
struct ScoreCard {
    let player: any PlayerProtocol
    let frames: [ScoreFrame]
    let score: Int
}
