//
//  ScoreFrameView.swift
//  BowlingGame
//
//  Created by Julia Ajhar on 2/8/24.
//

import SwiftUI

struct ScoreFrameView: View {
    @ObservedObject var viewModel: ScoreFrameViewModel
    
    init(
        viewModel: ScoreFrameViewModel
    ) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            Text("Frame: \(viewModel.frameCount)")
            Text(viewModel.rollText)
            Text("Score: \(viewModel.score)")
        }
        .frame(width: 150, height: 150)
        .background(.white)
        .cornerRadius(5)
        .shadow(color: viewModel.isActive ? .green : .gray.opacity(0.3), radius: 3)
    }
}

struct ScoreFrameView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreFrameView(
            viewModel: .init(
                scoreFrame: .init(),
                frameCount: 1,
                isActive: false
            )
        )
    }
}
