//
// Board model for Gomoku
//

import Foundation

public struct Board: Equatable, Codable {
    public let size: Int
    public private(set) var cells: [[Cell]]

    public init(size: Int = 15) {
        self.size = size
        let row = Array(repeating: Cell.empty, count: size)
        self.cells = Array(repeating: row, count: size)
    }

    public func isInBounds(row: Int, col: Int) -> Bool {
        return row >= 0 && row < size && col >= 0 && col < size
    }

    public func cell(atRow row: Int, col: Int) -> Cell? {
        guard isInBounds(row: row, col: col) else { return nil }
        return cells[row][col]
    }

    public mutating func place(_ move: Move) -> Bool {
        guard isInBounds(row: move.row, col: move.col) else { return false }
        guard case .empty = cells[move.row][move.col] else { return false }
        cells[move.row][move.col] = .stone(move.player)
        return true
    }

    public mutating func clear(atRow row: Int, col: Int) {
        guard isInBounds(row: row, col: col) else { return }
        cells[row][col] = .empty
    }
}


