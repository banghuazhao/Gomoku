# Gomoku iOS App

A SwiftUI-based iOS implementation of the classic Gomoku (Five in a Row 五子棋) board game.

## 📱 Available on the App Store

[![Download on the App Store](https://developer.apple.com/assets/elements/badges/download-on-the-app-store.svg)](https://apps.apple.com/us/app/gomoku-five-in-a-row-ai/id6751761102)

**Download now**: [Gomoku - Five in a Row AI](https://apps.apple.com/us/app/gomoku-five-in-a-row-ai/id6751761102)

## 🎮 About

Gomoku is a strategic board game where two players take turns placing stones on a grid. The first player to get five stones in a row (horizontally, vertically, or diagonally) wins the game.

## 📸 Screenshots

<p align="center">
  <img src="screenshots/1.png" width="250" alt="Main Menu" />
  <img src="screenshots/2.png" width="250" alt="Gameplay" />
  <img src="screenshots/3.png" width="250" alt="Settings" />
</p>

## ✨ Features

### ✅ Completed Features
- **Core Gameplay**: Local 2P and Single Player vs AI
- **Board Sizes**: 13×13, 15×15, 17×17 (configurable in Settings)
- **AI Difficulty**: Easy, Medium, Hard with intelligent move selection
- **Game Logic**: Turn management, win/draw detection, winning line highlight
- **Controls**: Restart, Undo, Hint system
- **UI**: Modern SwiftUI interface with wooden board design
- **Audio**: Background music and sound effects (toggleable)
- **Haptics**: Tactile feedback for moves and interactions (toggleable)
- **Settings**: Comprehensive game customization
- **First Player Selection**: Choose who goes first in single player mode

### 🔄 In Progress
- Game state persistence (resume games)
- Performance optimizations for larger board sizes

### 📋 Planned Features
- [ ] Game statistics and history
- [ ] Dark/Light theme support
- [ ] Accessibility improvements
- [ ] Game Center integration
- [ ] Online multiplayer

## 🛠 Technical Stack

- **Language**: Swift 5.9+
- **Frameworks**: SwiftUI, Combine, AVFoundation
- **Architecture**: MVVM-style with `@MainActor` state model
- **Testing**: XCTest
- **Platform**: iOS 17.0+

## 🏗 Project Structure

```
Gomoku/
├── Gomoku/
│   ├── App/
│   │   └── GomokuApp.swift        # App entry point
│   ├── Game/
│   │   ├── GameModel.swift        # @MainActor state model
│   │   ├── RulesEngine.swift      # Validation and win/draw detection
│   │   ├── AI.swift               # AI engine (Easy/Medium/Hard)
│   │   ├── AudioManager.swift     # Sound effects and background music
│   │   └── Haptics.swift          # Haptic feedback helpers
│   ├── Models/
│   │   ├── Player.swift           # Player enum and logic
│   │   ├── Cell.swift             # Cell state management
│   │   ├── Move.swift             # Move representation
│   │   └── Board.swift            # Board state and operations
│   ├── Style/
│   │   └── WoodButtonStyle.swift  # Custom wood-styled buttons
│   ├── Views/
│   │   ├── MainMenuView.swift     # Single Player / Two Players / Settings
│   │   ├── GameView.swift         # Game screen with toolbar and status
│   │   ├── BoardView.swift        # Interactive board with stones and win line
│   │   └── SettingsView.swift     # Game settings and preferences
│   ├── Assets.xcassets/           # App assets and icons
│   └── Musics/                    # Audio files
├── GomokuTests/
│   └── GomokuTests.swift          # Test suite
└── screenshots/                   # App screenshots
```

## 🚀 Getting Started

### Prerequisites
- Xcode 15.0 or later
- iOS 17.0+ deployment target
- macOS 14.0+ (for development)

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/banghuazhao/Gomoku.git
   cd Gomoku
   ```

2. Open the project in Xcode:
   ```bash
   open Gomoku.xcodeproj
   ```

3. Build and run the project (⌘+R)

## 🎯 How to Play

1. **Starting**: Choose who goes first in single player mode
2. **Turns**: Players alternate placing stones on empty intersections
3. **Objective**: Get five stones in a row (horizontally, vertically, or diagonally)
4. **Controls**:
   - Tap any empty intersection to place a stone
   - Use "Undo" to take back the last move
   - Use "Restart" to start a new game
   - Use "Hint" to get a suggested move (when available)
   - In Single Player, the AI moves automatically on its turn

## 🔧 Settings

- **Board Size**: Choose 13×13, 15×15, or 17×17
- **AI Difficulty**: Easy, Medium, Hard
- **Who Goes First**: Player or AI (single player mode)
- **Sound Effects**: Toggle background music and sound effects
- **Haptic Feedback**: Toggle tactile feedback

## 🤖 AI Overview

The AI engine features three difficulty levels:

- **Easy**: Random moves from candidate positions
- **Medium**: Heuristic-based scoring with immediate win/block detection
- **Hard**: Minimax algorithm with alpha-beta pruning (depth 2)

All levels prioritize immediate wins and blocking opponent's immediate wins.

## 🔊 Audio Features

- **Background Music**: Ambient background music that loops
- **Sound Effects**: 
  - Button taps
  - Stone placement
  - Game start
  - Win/lose/tie sounds
- **Audio Controls**: Toggle sound on/off in settings
- **Volume Management**: Different volume levels for different sound types

## 🎨 UI/UX Features

- **Wooden Design**: Authentic wooden board and button styling
- **Status Display**: Clear turn indicators and game state
- **Win Animation**: Highlighted winning line
- **Responsive Layout**: Adapts to different screen sizes
- **Haptic Feedback**: Tactile responses for interactions

## 🤝 Contributing

This is a personal project, but suggestions and feedback are welcome! Feel free to:
- Report bugs or issues
- Suggest new features
- Submit pull requests for improvements

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

## 👨‍💻 Author

**Banghua Zhao**
- GitHub: [@banghuazhao](https://github.com/banghuazhao)

## 🙏 Acknowledgments

- Inspired by the classic Gomoku board game
- Built with modern Swift and SwiftUI best practices
- Thanks to the Swift and iOS development community

---

**Note**: This project is actively being developed. Features and implementation details may change as the project evolves.
