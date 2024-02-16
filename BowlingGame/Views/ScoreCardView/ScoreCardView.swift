//
//  ScoreCardView.swift
//  BowlingGame
//
//  Created by Julia Ajhar on 2/8/24.
//

import SwiftUI

struct ScoreCardView: View {
    @ObservedObject var viewModel: ScoreCardViewModel
    @State private var rollInput: String = ""
    @FocusState private var rollFieldFocused: Bool
    
    @EnvironmentObject var coordinator: Coordinator

    var body: some View {
        ScrollViewReader { proxy in
            framesView
            infoView(scrollProxy: proxy)
        }
        .onTapGesture {
            rollFieldFocused = false
        }
    }
    
    private var framesView: some View {
        ScrollView([.vertical], showsIndicators: false) {
            VStack {
                ForEach(0..<viewModel.scoreCards.count, id: \.self) {
                    frames(forCard: viewModel.scoreCards[$0], index: $0)
                }
            }
        }
    }
    
    func frames(forCard scoreCard: ScoreCard, index: Int) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("\(scoreCard.player.name)")
                .font(.title)
                .padding(.leading, 10)
            
            ScrollView([.horizontal], showsIndicators: false) {
                LazyHStack(spacing: 10) {
                    ForEach(0..<scoreCard.frames.count, id: \.self) {
                        ScoreFrameView(
                            viewModel: .init(
                                scoreFrame: scoreCard.frames[$0],
                                frameCount: $0 + 1,
                                isActive: $0 == viewModel.currentFrameNumber &&
                                viewModel.currentPlayer.id == scoreCard.player.id
                            )
                        )
                        .id(scoreCard.frames[$0].id)
                    }
                }
                .padding(10)
            }
        }
    }
    
    private func infoView(scrollProxy: ScrollViewProxy? = nil) -> some View {
        VStack {
            Group {
                playerInfoView
                
                if viewModel.isEndOfGame {
                    endOfGameMessage
                } else if let error = viewModel.error {
                    errorMessage(error)
                }
                
                rollInputView(scrollProxy: scrollProxy)
                    .padding(.vertical, 10)
                ctaButtons(scrollProxy: scrollProxy)
            }
        }
        .overlay(Divider(), alignment: .top)
        .background(
            Color.white
                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 0)
                .mask(Rectangle().padding(.top, -20))
        )

    }
    
    var playerInfoView: some View {
        VStack {
            HStack {
                VStack(
                    alignment: .leading,
                    spacing: 8
                ) {
                    Text("\(viewModel.currentPlayer.name)")
                        .font(.title)
                    Text("Score: \(viewModel.score)")
                        .font(.title2)
                }
                Spacer()
            }
        }
        .padding()
        .overlay(Divider(), alignment: .bottom)
    }
    
    private func rollInputView(scrollProxy: ScrollViewProxy? = nil) -> some View {
        VStack {
            TextField("Pins", text: $rollInput)
                .textFieldStyle(OvalTextFieldStyle())
                .fontWeight(.bold)
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
                .disableAutocorrection(true)
                .frame(maxWidth: 100)
                .focused($rollFieldFocused)
        }
    }
    
    private func ctaButtons(scrollProxy: ScrollViewProxy? = nil) -> some View {
        VStack(spacing: 20) {
            Button (action: {
                if let value = Int(rollInput) {
                    if viewModel.roll(pinsKnocked: value) {
                        resetRollInput()
                        
                        withAnimation {
                            scrollProxy?.scrollTo(viewModel.currentFrame.id)
                        }
                    }
                }
            }, label: {
                Text("Roll")
                    .font(.title2)
                    .fontWeight(.bold)
            })
            .frame(minWidth: 150)
            .padding()
            .foregroundColor(.white)
            .background(Color(red: 0, green: 0, blue: 0.5))
            .clipShape(Capsule())
            
            Button (action: {
                viewModel.resetGame()
                resetRollInput()
                
                withAnimation {
                    for id in viewModel.startingFrameIds {
                        // scroll all scrollviews back to starting frames
                        scrollProxy?.scrollTo(id)
                    }
                }
            }, label: {
                Text("Reset Game")
                    .font(.title2)
                    .fontWeight(.medium)
            })
            .frame(minWidth: 150)
            .padding()
            .foregroundColor(.white)
            .background(Color(red: 0.8, green: 0, blue: 0))
            .clipShape(Capsule())
        }
    }
    
    private func errorMessage(_ error: ScoreCardViewModelError) -> some View {
        Text(error.message)
            .foregroundColor(.red)
            .font(.callout)
            .fontWeight(.medium)
    }
    
    private var endOfGameMessage: some View {
        Text("Game Over")
            .foregroundColor(.blue)
            .font(.title)
            .fontWeight(.bold)
    }
    
    private func resetRollInput() {
        rollInput = ""
        rollFieldFocused = false
    }
}

struct ScoreCardView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreCardView(
            viewModel: .init(
                game: Game(players: [
                    Player(name: "Player 1"),
                    Player(name: "Player 2")
                ])
            )
        )
    }
}
