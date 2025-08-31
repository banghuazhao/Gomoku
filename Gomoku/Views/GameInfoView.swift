//
// Game Info View - History, Rules, and AI Levels
//

import SwiftUI

struct GameInfoView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                Image("background")
                    .resizable()
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 30) {
                        // Title
                        Text("GOMOKU")
                            .font(.system(size: 36, weight: .bold, design: .serif))
                            .foregroundColor(.primary)
                            .shadow(color: .white.opacity(0.8), radius: 2, x: 1, y: 1)
                            .padding(.top, 20)
                        
                        VStack(spacing: 25) {
                            // History Section
                            InfoSection(
                                title: "History",
                                icon: "book.fill",
                                content: """
                                Gomoku (五目), also known as Five in a Row, is a traditional strategy board game that originated in ancient China over 4,000 years ago. The name "Gomoku" comes from Japanese, meaning "five stones."
                                
                                The game was introduced to Japan in the 7th century and later spread to Korea and other parts of Asia. It's considered one of the oldest board games still played today and has influenced many modern strategy games.
                                
                                In the 19th century, Gomoku gained popularity in Europe and has since become a beloved game worldwide, known for its simple rules but deep strategic complexity.
                                """
                            )
                            
                            // Rules Section
                            InfoSection(
                                title: "Rules",
                                icon: "list.bullet",
                                content: """
                                • **Objective**: Be the first player to place five stones in a row (horizontally, vertically, or diagonally)
                                
                                • **Gameplay**: Players take turns placing their stones (black and white) on the intersections of a 15×15 grid
                                
                                • **Winning**: The first player to create an unbroken line of five stones wins
                                
                                • **Draw**: If the board is completely filled without a winner, the game is a draw
                                
                                • **Strategy**: Players must balance offensive moves (creating threats) with defensive moves (blocking opponent's threats)
                                
                                • **No Capturing**: Unlike Go, stones are never removed from the board once placed
                                """
                            )
                            
                            // AI Levels Section
                            InfoSection(
                                title: "AI Difficulty Levels",
                                icon: "brain.head.profile",
                                content: """
                                **Easy Level**:
                                • Random placement near existing stones
                                • Basic win/block detection
                                • Suitable for beginners
                                
                                **Medium Level**:
                                • Heuristic-based evaluation
                                • Analyzes board positions for threats
                                • Considers both offensive and defensive moves
                                • Uses scoring system for different patterns (fives, fours, threes, twos)
                                
                                **Hard Level**:
                                • Minimax algorithm with Alpha-Beta pruning
                                • Looks ahead 2 moves
                                • Advanced pattern recognition
                                • Strategic planning and threat analysis
                                • Most challenging opponent
                                """
                            )
                            
                            // Strategy Tips
                            InfoSection(
                                title: "Strategy Tips",
                                icon: "lightbulb.fill",
                                content: """
                                • **Control the Center**: The center of the board offers more opportunities for creating multiple threats
                                
                                • **Create Forks**: Try to create positions where you have multiple winning threats simultaneously
                                
                                • **Block Aggressively**: Don't just block your opponent's immediate threats; look for developing threats
                                
                                • **Think Ahead**: Consider not just your next move, but how it sets up future moves
                                
                                • **Pattern Recognition**: Learn to recognize common patterns like open fours, closed fours, and open threes
                                
                                • **Balance**: Maintain a balance between attacking and defending
                                """
                            )
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 30)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
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
            }
        }
    }
}

struct InfoSection: View {
    let title: String
    let icon: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(.white)
                
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer()
            }
            
            Text(LocalizedStringKey(content))
                .font(.body)
                .foregroundColor(.white.opacity(0.9))
                .lineSpacing(4)
                .multilineTextAlignment(.leading)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.black.opacity(0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

#Preview {
    GameInfoView()
}
