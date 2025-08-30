//
// SwiftUI BoardView with tap handling
//

import SwiftUI
import UIKit

struct BoardView: View {
    @ObservedObject var model: GameModel

    var body: some View {
        GeometryReader { geo in
            let size = min(geo.size.width, geo.size.height)
            let cellSize = size / CGFloat(model.board.size)
            let padding = cellSize / 2

            ZStack {
                // Board - wooden board with grid and star points
                Image("board")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size, height: size)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(color: .black.opacity(0.3), radius: 5, x: 2, y: 2)
                
                Path { path in
                    for i in 0..<model.board.size {
                        let p = CGFloat(i) * cellSize + padding
                        path.move(to: CGPoint(x: padding, y: p))
                        path.addLine(to: CGPoint(x: size - padding, y: p))
                        path.move(to: CGPoint(x: p, y: padding))
                        path.addLine(to: CGPoint(x: p, y: size - padding))
                    }
                }
                .stroke(Color.black, lineWidth: 0.8)
                .shadow(color: .white.opacity(0.5), radius: 1, x: 1, y: 1)

                // Star points (hoshi)
                ForEach([3, model.board.size - 4], id: \.self) { row in
                    ForEach([3, model.board.size - 4], id: \.self) { col in
                        Circle()
                            .fill(Color.black)
                            .frame(width: 6, height: 6)
                            .position(
                                x: CGFloat(col) * cellSize + padding,
                                y: CGFloat(row) * cellSize + padding
                            )
                    }
                }
                
                Circle()
                    .fill(Color.black)
                    .frame(width: 6, height: 6)
                    .position(
                        x: CGFloat(model.board.size / 2) * cellSize + padding,
                        y: CGFloat(model.board.size / 2) * cellSize + padding
                    )

                // Stones
                ForEach(0..<model.board.size, id: \.self) { r in
                    ForEach(0..<model.board.size, id: \.self) { c in
                        let x = CGFloat(c) * cellSize + padding
                        let y = CGFloat(r) * cellSize + padding
                        Group {
                            switch model.board.cells[r][c] {
                            case .empty:
                                EmptyView()
                            case .stone(let player, let isMarked):
                                ZStack {
                                    Image(player == .black ? "black" : "white")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: cellSize, height: cellSize)
                                    
                                    if isMarked {
                                        Circle()
                                            .fill(Color.red)
                                            .frame(width: cellSize * 0.15, height: cellSize * 0.15)
                                            .shadow(color: .white, radius: 1)
                                    }
                                }
                                .position(x: x, y: y)
                            }
                        }
                    }
                }

                // Winning line highlight
                if !model.winningLine.isEmpty {
                    Path { path in
                        guard let first = model.winningLine.first, let last = model.winningLine.last else { return }
                        let start = CGPoint(x: (CGFloat(first.col) + 0.5) * cellSize, y: (CGFloat(first.row) + 0.5) * cellSize)
                        let end = CGPoint(x: (CGFloat(last.col) + 0.5) * cellSize, y: (CGFloat(last.row) + 0.5) * cellSize)
                        path.move(to: start)
                        path.addLine(to: end)
                    }
                    .stroke(Color.red, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                }
            }
            .frame(width: size, height: size)
            .contentShape(Rectangle())
            .onTapGesture { location in
                let origin = CGPoint(x: (geo.size.width - size) / 2, y: (geo.size.height - size) / 2)
                let point = CGPoint(x: location.x - origin.x, y: location.y - origin.y)
                guard point.x >= 0 && point.y >= 0 && point.x <= size && point.y <= size else { return }
                let col = Int(point.x / cellSize)
                let row = Int(point.y / cellSize)
                if model.placeStone(row: row, col: col) {
                    Haptics.impact(.light)
                } else {
                    Haptics.notify(.warning)
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}



#Preview {
    BoardView(model: GameModel())
        .padding()
}
