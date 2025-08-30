//
// Main Menu View
//

import SwiftUI

struct MainMenuView: View {
    @State private var showingGame = false
    @State private var showingSettings = false
    @State private var gameMode: GameMode = .p2p
    
    enum GameMode {
        case singlePlayer
        case p2p
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                Image("background")
                    .resizable()
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    Spacer()
                    
                    // Title
                    VStack(spacing: 10) {
                        Text("GOMOKU")
                            .font(.system(size: 48, weight: .bold, design: .serif))
                            .foregroundColor(.primary)
                            .shadow(color: .white.opacity(0.8), radius: 2, x: 1, y: 1)
                    }
                    
                    Spacer()
                    
                    // Menu Buttons
                    VStack(spacing: 20) {
                        MenuButton(
                            title: "Single Player",
                            subtitle: "vs AI",
                            icon: "person.fill"
                        ) {
                            gameMode = .singlePlayer
                            showingGame = true
                        }
                        
                        MenuButton(
                            title: "Two Players",
                            subtitle: "Local Game",
                            icon: "person.2.fill"
                        ) {
                            gameMode = .p2p
                            showingGame = true
                        }
                        
                        MenuButton(
                            title: "Settings",
                            subtitle: "Game Options",
                            icon: "gearshape.fill"
                        ) {
                            showingSettings = true
                        }
                    }
                    .padding(.horizontal, 40)
                    
                    Spacer()
                }
            }
            .navigationDestination(isPresented: $showingGame) {
                GameView(gameMode: gameMode)
            }
            .navigationDestination(isPresented: $showingSettings) {
                SettingsView()
            }
            .onAppear {
                AudioManager.shared.playBackgroundMusic()
            }
        }
    }
}

struct MenuButton: View {
    let title: String
    let subtitle: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            AudioManager.shared.playButtonTap()
            action()
        }) {
            HStack(spacing: 15) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(width: 30)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.white)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.6))
            }
        }
        .buttonStyle(.woodStyle)
    }
}

#Preview {
    MainMenuView()
}
