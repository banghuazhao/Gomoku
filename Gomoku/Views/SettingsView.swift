//
// Settings View
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("boardSize") private var boardSize = 15
    @AppStorage("aiDifficulty") private var aiDifficulty = "Medium"
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                Image("background")
                    .resizable()
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    // Settings Content
                    VStack(spacing: 25) {
                        SettingRow(
                            title: "Board Size",
                            subtitle: "\(boardSize) x \(boardSize)",
                            icon: "square.grid.3x3"
                        ) {
                            // TODO: Add board size picker
                        }
                        
                        SettingRow(
                            title: "AI Difficulty",
                            subtitle: aiDifficulty,
                            icon: "brain.head.profile"
                        ) {
                            // TODO: Add AI difficulty picker
                        }
                        
                        SettingRow(
                            title: "Sound Effects",
                            subtitle: "On",
                            icon: "speaker.wave.2"
                        ) {
                            // TODO: Add sound toggle
                        }
                        
                        SettingRow(
                            title: "Haptic Feedback",
                            subtitle: "On",
                            icon: "hand.tap"
                        ) {
                            // TODO: Add haptic toggle
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
        }
    }
}

struct SettingRow: View {
    let title: String
    let subtitle: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
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
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.black.opacity(0.6))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    SettingsView()
}
