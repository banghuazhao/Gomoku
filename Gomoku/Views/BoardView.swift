//
// SwiftUI BoardView with tap handling
//

import SwiftUI

struct BoardView: View {
    @ObservedObject var model: GameModel

    private let gridColor = Color.secondary.opacity(0.6)

    var body: some View {
        GeometryReader { geo in
            let size = min(geo.size.width, geo.size.height)
            let cellSize = size / CGFloat(model.board.size)

            ZStack {
                // Grid
                Path { path in
                    for i in 0...model.board.size {
                        let p = CGFloat(i) * cellSize
                        path.move(to: CGPoint(x: 0, y: p))
                        path.addLine(to: CGPoint(x: size, y: p))
                        path.move(to: CGPoint(x: p, y: 0))
                        path.addLine(to: CGPoint(x: p, y: size))
                    }
                }
                .stroke(gridColor, lineWidth: 1)

                // Stones
                ForEach(0..<model.board.size, id: \.self) { r in
                    ForEach(0..<model.board.size, id: \.self) { c in
                        let x = (CGFloat(c) + 0.5) * cellSize
                        let y = (CGFloat(r) + 0.5) * cellSize
                        Group {
                            switch model.board.cells[r][c] {
                            case .empty:
                                EmptyView()
                            case .stone(let player):
                                Circle()
                                    .fill(player == .black ? Color.black : Color.white)
                                    .overlay(Circle().stroke(Color.black.opacity(0.6), lineWidth: 1))
                                    .frame(width: cellSize * 0.8, height: cellSize * 0.8)
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
                guard point.x >= 0 && point.y >= 0 && point.x < size && point.y < size else { return }
                let col = Int(point.x / cellSize)
                let row = Int(point.y / cellSize)
                _ = model.placeStone(row: row, col: col)
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .padding()
    }
}


