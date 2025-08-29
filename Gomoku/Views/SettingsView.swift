//
// Settings View
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("boardSize") private var boardSize = 15
    @AppStorage("aiDifficulty") private var aiDifficulty = "Medium"
    @AppStorage("hapticsEnabled") private var hapticsEnabled: Bool = true
    @StateObject private var audioManager = AudioManager.shared
    
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
                        SettingBoardSizeRow(selection: $boardSize)
                        
                        SettingDifficultyRow(selection: $aiDifficulty)
                        
                        SettingToggleRow(
                            title: "Sound Effects",
                            isOn: $audioManager.isSoundEnabled,
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

            Spacer(minLength: 0)
        }
        .font(.headline)
        .foregroundColor(.white)
        .padding(.vertical, 12)
        .padding(.horizontal, 18)
        .background(
            Image("board")
                .resizable()
                .scaledToFill()
                .clipShape(RoundedRectangle(cornerRadius: 12))
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .contentShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 2)
    }
}

struct SettingDifficultyRow: View {
    @Binding var selection: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: "brain.head.profile")
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(width: 30)

                Text("AI Difficulty")
                    .font(.headline)
                    .foregroundColor(.white)
            }

            Picker("AI Difficulty", selection: $selection) {
                ForEach(AIDifficulty.allCases, id: \.rawValue) { level in
                    Text(level.rawValue).tag(level.rawValue)
                }
            }
            .pickerStyle(.segmented)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 18)
        .background(
            Image("board")
                .resizable()
                .scaledToFill()
                .clipShape(RoundedRectangle(cornerRadius: 12))
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .contentShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 2)
        .onChange(of: selection) { _, _ in
            Haptics.selection()
        }
    }
}

struct SettingBoardSizeRow: View {
    @Binding var selection: Int

    private let options: [Int] = [9, 12, 15]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: "square.grid.3x3")
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(width: 30)

                Text("Board Size")
                    .font(.headline)
                    .foregroundColor(.white)
            }

            Picker("Board Size", selection: $selection) {
                ForEach(options, id: \.self) { size in
                    Text("\(size) x \(size)").tag(size)
                }
            }
            .pickerStyle(.segmented)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 18)
        .background(
            Image("board")
                .resizable()
                .scaledToFill()
                .clipShape(RoundedRectangle(cornerRadius: 12))
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .contentShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 2)
        .onChange(of: selection) { _, _ in
            Haptics.selection()
        }
    }
}

#Preview {
    SettingsView()
}
