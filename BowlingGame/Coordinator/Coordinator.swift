//
//  Coordinator.swift
//  BowlingGame
//
//  Created by Julia Ajhar on 2/9/24.
//

import SwiftUI

enum Page: Identifiable {
    case playerEntry
    case game(players: [PlayerProtocol])
    
    var id: String {
        switch self {
        case .playerEntry:
            return "playerEntry"
        case .game:
            return "gameView"
        }
    }
}

extension Page: Hashable {
    func hash(into myhasher: inout Hasher) {
        // Using id to uniquely identify each person.
        myhasher.combine(id)
    }
    
    static func == (lhs: Page, rhs: Page) -> Bool {
        switch (lhs, rhs) {
        case (.playerEntry, .playerEntry):
            return true
        case (.game, .game):
            return true
        default:
            return false
        }
    }
}

protocol CoordinatorPathHandlerProtocol {
    func push(_ page: Page, path: inout NavigationPath)
    func pop(path: inout NavigationPath)
    func popToRoot(path: inout NavigationPath)
}

struct CoordinatorPathHandler: CoordinatorPathHandlerProtocol {
    func push(_ page: Page, path: inout NavigationPath) {
        path.append(page)
    }
    
    func pop(path: inout NavigationPath) {
        path.removeLast()
    }
    
    func popToRoot(path: inout NavigationPath) {
        path.removeLast(path.count)
    }
}

class Coordinator: ObservableObject {
    @Published var path = NavigationPath()
    
    private let pathHandler: CoordinatorPathHandlerProtocol
    
    init(pathHandler: CoordinatorPathHandlerProtocol = CoordinatorPathHandler()) {
        self.pathHandler = pathHandler
    }
    
    func push(_ page: Page) {
        pathHandler.push(page, path: &path)
    }
    
    func pop() {
        pathHandler.pop(path: &path)
    }
    
    func popToRoot() {
        pathHandler.popToRoot(path: &path)
    }
    
    @ViewBuilder
    func build(page: Page) -> some View {
        switch page {
        case .playerEntry:
            PlayerEntryView(viewModel: .init())
        case .game(let players):
            ScoreCardView(
                viewModel: .init(
                    game: Game(players: players)
                )
            )
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Game")
        }
    }
}
