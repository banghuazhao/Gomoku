//
// Main game screen
//

import SwiftUI

struct GameView: View {
    @StateObject private var model = GameModel()
    @Environment(\.dismiss) private var dismiss
    @AppStorage("aiDifficulty") private var difficultyRaw = "Medium"
    @AppStorage("boardSize") private var boardSize: Int = 15
    @AppStorage("whoGoesFirst") private var whoGoesFirst = "Player"
    @State private var showingSettings = false
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
                
                BannerView()
                    .frame(height: 50)
                    .padding(.bottom, 16)
            }
            .frame(maxWidth: 800)
        }
        .onAppear {
            if model.board.size != boardSize {
                model.reset(boardSize: boardSize)
            }
            if gameMode == .singlePlayer {
                let diff = AIDifficulty(rawValue: difficultyRaw) ?? .medium
                let startingPlayer: Player = whoGoesFirst == "AI" ? .white : .black
                model.configureSinglePlayer(enabled: true, aiAs: .white, difficulty: diff)
                model.reset(boardSize: boardSize, starting: startingPlayer)
            } else {
                model.configureSinglePlayer(enabled: false)
            }
        }
        .onChange(of: boardSize) { _, newValue in
            model.reset(boardSize: newValue)
        }
        .onChange(of: difficultyRaw) { _, newValue in
            let diff = AIDifficulty(rawValue: newValue) ?? .medium
            if gameMode == .singlePlayer {
                model.configureSinglePlayer(enabled: true, aiAs: .white, difficulty: diff)
            }
        }
        .onChange(of: whoGoesFirst) { _, newValue in
            if gameMode == .singlePlayer {
                let startingPlayer: Player = newValue == "AI" ? .white : .black
                model.reset(boardSize: boardSize, starting: startingPlayer)
            }
        }
        .navigationBarBackButtonHidden()
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    AudioManager.shared.playButtonTap()
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
                Button(action: {
                    AudioManager.shared.playButtonTap()
                    showingSettings = true
                }) {
                    Image(systemName: "gearshape.fill")
                        .font(.headline)
                }
                .buttonStyle(.woodStyle)

                Button("Restart") {
                    AudioManager.shared.playButtonTap()
                    if gameMode == .singlePlayer {
                        let startingPlayer: Player = whoGoesFirst == "AI" ? .white : .black
                        model.reset(boardSize: boardSize, starting: startingPlayer)
                    } else {
                        model.reset()
                    }
                }
                .buttonStyle(.woodStyle)

                Button("Undo") {
                    AudioManager.shared.playButtonTap()
                    model.undo()
                }
                .buttonStyle(.woodStyle)
            }
        }
    }

    private var status: some View {
        HStack {
            Group {
                if model.isGameOver {
                    HStack(spacing: 8) {
                        Image(systemName: model.winner == nil ? "equal.circle.fill" : "crown.fill")
                            .foregroundColor(
                                model.winner == nil ? .white : .yellow
                            )
                            .font(.headline)
                            .frame(width: 24, height: 24)
                        
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
            .frame(minWidth: 150)
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(
                Image(.board)
                    .resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            )
            
            Spacer()
            
            // Hint button - only show when game is not over
            if !model.isGameOver {
                Button(action: {
                    model.placeHint()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "lightbulb.fill")
                            .font(.headline)
                            .foregroundColor(.white)
                        Text("Hint")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
                }
                .buttonStyle(.woodStyle)
            }
        }
    }
}

#Preview {
    NavigationStack {
        GameView()
    }
}
