//
// Board model for Gomoku
//

import Foundation

public struct Board: Equatable, Codable {
    public let size: Int
    public private(set) var cells: [[Cell]]
    public private(set) var lastMove: Move?

    public init(size: Int = 15) {
        self.size = size
        let row = Array(repeating: Cell.empty, count: size)
        self.cells = Array(repeating: row, count: size)
        self.lastMove = nil
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
        
        // Unmark the previous last move
        if let lastMove = lastMove {
            if case .stone(let player, _) = cells[lastMove.row][lastMove.col] {
                cells[lastMove.row][lastMove.col] = .stone(player, isMarked: false)
            }
        }
        
        // Place the new stone as marked
        cells[move.row][move.col] = .stone(move.player, isMarked: true)
        lastMove = move
        return true
    }

    public mutating func clear(atRow row: Int, col: Int) {
        guard isInBounds(row: row, col: col) else { return }
        cells[row][col] = .empty
        
        // If we're clearing the last move, update lastMove
        if let lastMove = lastMove, lastMove.row == row && lastMove.col == col {
            self.lastMove = nil
        }
    }
    
    public mutating func markAsLastMove(_ move: Move) {
        guard isInBounds(row: move.row, col: move.col) else { return }
        if case .stone(let player, _) = cells[move.row][move.col] {
            cells[move.row][move.col] = .stone(player, isMarked: true)
            lastMove = move
        }
    }
}


