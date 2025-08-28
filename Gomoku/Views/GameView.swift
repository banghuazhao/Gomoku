//
// Main game screen
//

import SwiftUI

struct GameView: View {
    @StateObject private var model = GameModel()
    @Environment(\.dismiss) private var dismiss
    @AppStorage("aiDifficulty") private var difficultyRaw = "Medium"
    let gameMode: MainMenuView.GameMode

    init(gameMode: MainMenuView.GameMode = .p2p) {
        self.gameMode = gameMode
    }

    var body: some View {
        ZStack {
            // Background
            Image("background")
                .resizable()
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Spacer()
                    .frame(height: 20)

                HStack(spacing: 8) {
                    status
                }
                .padding(.horizontal, 20)

                BoardView(model: model)
                    .padding(.horizontal, 16)

                Spacer()
            }
        }
        .onAppear {
            if gameMode == .singlePlayer {
                let diff = AIDifficulty(rawValue: difficultyRaw) ?? .medium
                model.configureSinglePlayer(enabled: true, aiAs: .white, difficulty: diff)
            } else {
                model.configureSinglePlayer(enabled: false)
            }
        }
        .onChange(of: difficultyRaw) { _, newValue in
            let diff = AIDifficulty(rawValue: newValue) ?? .medium
            if gameMode == .singlePlayer {
                model.configureSinglePlayer(enabled: true, aiAs: .white, difficulty: diff)
            }
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    HStack(spacing: 5) {
                        Image(systemName: "chevron.left")
                            .font(.headline)
                        Text("Menu")
                    }
                }
                .buttonStyle(.woodStyle)
            }

            ToolbarItemGroup(placement: .topBarTrailing) {
                Button("Restart") {
                    model.reset()
                }
                .buttonStyle(.woodStyle)

                Button("Undo") {
                    model.undo()
                }
                .buttonStyle(.woodStyle)
            }
        }
    }

    private var status: some View {
        HStack {
            if model.isGameOver {
                HStack(spacing: 8) {
                    Image(systemName: model.winner == nil ? "equal.circle.fill" : "crown.fill")
                        .foregroundColor(
                            model.winner == nil ? .white : .yellow
                        )
                        .font(.headline)

                    Text(
                        model.winner == nil ? "Draw Game" : "Winner: \(model.winner == .black ? "Black" : "White")")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
            } else {
                HStack(spacing: 8) {
                    Image(model.currentPlayer == .black ? .black : .white)
                        .resizable()
                        .frame(width: 24, height: 24)

                    Text("\(model.currentPlayer == .black ? "Black turn" : "White turn")")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
            }
        }
        .frame(minWidth: 150, minHeight: 32)
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(
            Image(.board)
                .resizable()
                .clipShape(RoundedRectangle(cornerRadius: 10))
        )
    }
}

#Preview {
    NavigationStack {
        GameView()
    }
}
