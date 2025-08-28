//
// Settings View
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("boardSize") private var boardSize = 15
    @AppStorage("aiDifficulty") private var aiDifficulty = "Medium"
    @AppStorage("hapticsEnabled") private var hapticsEnabled: Bool = true
    
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
                        
                        // Difficulty Picker
                        VStack(alignment: .leading, spacing: 8) {
                            Text("AI Difficulty")
                                .font(.headline)
                                .foregroundColor(.white)
                            Picker("AI Difficulty", selection: $aiDifficulty) {
                                ForEach(AIDifficulty.allCases, id: \.rawValue) { level in
                                    Text(level.rawValue).tag(level.rawValue)
                                }
                            }
                            .pickerStyle(.segmented)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.black.opacity(0.4))
                            )
                        }
                        .padding(.horizontal, 20)
                        
                        SettingToggleRow(
                            title: "Sound Effects",
                            isOn: .constant(true),
                            icon: "speaker.wave.2"
                        )
                        
                        SettingToggleRow(
                            title: "Haptic Feedback",
                            isOn: $hapticsEnabled,
                            icon: "hand.tap"
                        )
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

struct SettingToggleRow: View {
    let title: String
    @Binding var isOn: Bool
    let icon: String

    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.white)
                .frame(width: 30)

            Toggle(isOn: $isOn) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .tint(.white)

            Spacer()
        }
        .buttonStyle(.woodStyle)
        .padding(.vertical, 6)
    }
}

#Preview {
    SettingsView()
}
