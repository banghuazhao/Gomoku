//
// Main game screen
//

import SwiftUI

struct GameView: View {
    @StateObject private var model = GameModel()

    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                header
                    .padding(.horizontal)
                BoardView(model: model)
                    .padding(.horizontal, 8)
                controls
            }
            
        }
    }

    private var header: some View {
        HStack {
            if model.isGameOver {
                Text(model.winner == nil ? "Draw" : "Winner: \(model.winner == .black ? "Black" : "White")")
                    .font(.headline)
            } else {
                Text("Turn: \(model.currentPlayer == .black ? "Black" : "White")")
                    .font(.headline)
            }
            Spacer()
        }
    }

    private var controls: some View {
        HStack(spacing: 12) {
            Button("New Game") { model.reset() }
            Button("Undo") { _ = model.undo() }
            Button("Redo") { _ = model.redo() }
        }
    }
}

#Preview {
    GameView()
}


