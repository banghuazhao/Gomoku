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
                    .padding(20)
                    
                    Spacer()
                }
            }
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
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
        }
        .buttonStyle(.woodStyle)
    }
}

#Preview {
    SettingsView()
}
