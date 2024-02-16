//
//  CoordinatorView.swift
//  BowlingGame
//
//  Created by Julia Ajhar on 2/9/24.
//

import SwiftUI

struct CoordinatorView: View {
    @StateObject private var coordinator = Coordinator()
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.build(page: .playerEntry)
            .navigationDestination(for: Page.self) { page in
                coordinator.build(page: page)
            }
        }
        .environmentObject(coordinator)
    }
}

struct CoordinatorView_Previews: PreviewProvider {
    static var previews: some View {
        CoordinatorView()
    }
}
