//
//  PlayerEntryView.swift
//  BowlingGame
//
//  Created by Julia Ajhar on 2/16/24.
//

import SwiftUI

struct PlayerEntryView: View {
    @EnvironmentObject var coordinator: Coordinator
    @ObservedObject var viewModel: PlayerEntryViewModel
    @State var nameFieldValue: String = ""
    
    var body: some View {
        VStack {
            Text("Enter Player Name")
            TextField("Name", text: $nameFieldValue)
                .textFieldStyle(OvalTextFieldStyle())
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .disableAutocorrection(true)
                .frame(maxWidth: 200)
            
            VStack(spacing: 20) {
                Button("Add player") {
                    viewModel.addPlayer(withName: nameFieldValue)
                }
                .disabled(nameFieldValue.isEmpty)
                
                Button("Let's Bowl!") {
                    coordinator.push(.game(players: viewModel.players))
                }
                .disabled(!viewModel.canBowl)
            }
        }
    }
}

#Preview {
    PlayerEntryView(
        viewModel: .init()
    )
}
