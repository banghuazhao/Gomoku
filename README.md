# Gomoku iOS App

A SwiftUI-based iOS implementation of the classic Gomoku (Five in a Row) board game.

## 🎮 About

Gomoku is a strategic board game where two players take turns placing stones on a 15x15 grid. The first player to get five stones in a row (horizontally, vertically, or diagonally) wins the game.

## 🚧 Status: Work in Progress

This project is currently under active development. Core gameplay is implemented and functional, with additional features planned.

### ✅ Completed Features
- **Core Gameplay**: 15x15 board with two-player local play
- **Game Logic**: Win detection, draw detection, turn management
- **UI**: SwiftUI-based interface with tappable board
- **Game Controls**: New game, undo, redo functionality
- **Visual Feedback**: Winning line highlighting, current player indication

### 🔄 In Progress
- Game state persistence
- AI opponent implementation
- Enhanced UI/UX improvements
- Performance optimizations

### 📋 Planned Features
- [ ] AI opponent with difficulty levels
- [ ] Game statistics and history
- [ ] Multiple board sizes
- [ ] Sound effects and haptics
- [ ] Dark/light theme support
- [ ] Accessibility improvements
- [ ] Game Center integration (optional)

## 🛠 Technical Stack

- **Language**: Swift 5.9+
- **Framework**: SwiftUI
- **Architecture**: MVVM with `@MainActor` for state management
- **Testing**: XCTest framework
- **Platform**: iOS 17.0+

## 🏗 Project Structure

```
Gomoku/
├── App/
│   └── GomokuApp.swift      # App entry point
├── Game/
│   ├── GameModel.swift      # Game state management (@MainActor)
│   └── RulesEngine.swift    # Game rules and win detection
├── Models/
│   ├── Player.swift         # Player enum and utilities
│   ├── Cell.swift           # Cell state enum
│   ├── Move.swift           # Move struct
│   └── Board.swift          # Board model and operations
├── Views/
│   ├── ContentView.swift    # Root view
│   ├── GameView.swift       # Main game screen
│   └── BoardView.swift      # Interactive board component
└── Assets.xcassets/         # App assets and icons

GomokuTests/
└── GomokuTests.swift        # Test suite
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

1. **Starting**: Black plays first
2. **Turns**: Players alternate placing stones on empty intersections
3. **Objective**: Get five stones in a row (horizontally, vertically, or diagonally)
4. **Controls**:
   - Tap any empty intersection to place a stone
   - Use "Undo" to take back the last move
   - Use "Redo" to replay an undone move
   - Use "New Game" to start over

## 🧪 Testing

Run the test suite using XCTest:
```bash
# In Xcode: Product > Test (⌘+U)
# Or via command line:
xcodebuild test -project Gomoku.xcodeproj -scheme Gomoku
```

Current test coverage includes:
- Win detection logic
- Game session state management
- Undo/redo functionality

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
