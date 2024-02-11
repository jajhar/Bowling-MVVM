//
//  Coordinator.swift
//  BowlingGame
//
//  Created by Julia Ajhar on 2/9/24.
//

import SwiftUI

enum Page: String, Identifiable {
    case playerEntry
    case game
    
    var id: String {
        rawValue
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
            VStack {
                Text("TODO?")
            }
        case .game:
            ScoreCardView(
                viewModel: .init(
                    game: Game(players: [
                        Player(name: "Julia"),
//                        Player(name: "Tyler") // uncomment for additional player(s)
                    ])
                )
            )
        }
    }
}
