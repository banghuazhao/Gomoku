//
// Rules engine for validation and win detection
//

import Foundation

public struct WinResult: Equatable {
    public let winner: Player
    public let line: [Move]
}

public enum GameResolution: Equatable {
    case ongoing
    case win(WinResult)
    case draw
}

public struct RulesEngine {
    public init() {}

    public func validatePlacement(board: Board, move: Move) -> Bool {
        guard board.isInBounds(row: move.row, col: move.col) else { return false }
        guard case .empty = board.cells[move.row][move.col] else { return false }
        return true
    }

    public func evaluateBoardAfterMove(board: Board, lastMove: Move) -> GameResolution {
        if let win = checkWin(board: board, lastMove: lastMove) {
            return .win(win)
        }
        let isFull = !board.cells.flatMap { $0 }.contains { cell in
            if case .empty = cell { return true } else { return false }
        }
        return isFull ? .draw : .ongoing
    }

    private func checkWin(board: Board, lastMove: Move) -> WinResult? {
        let directions: [(dr: Int, dc: Int)] = [
            (0, 1),   // horizontal
            (1, 0),   // vertical
            (1, 1),   // diag down-right
            (1, -1)   // diag down-left
        ]

        for dir in directions {
            let line = contiguousLine(board: board, from: lastMove, dr: dir.dr, dc: dir.dc)
            if line.count >= 5 {
                return WinResult(winner: lastMove.player, line: Array(line.prefix(5)))
            }
        }
        return nil
    }

    private func contiguousLine(board: Board, from move: Move, dr: Int, dc: Int) -> [Move] {
        var result: [Move] = [move]
        // extend positive direction
        var r = move.row + dr
        var c = move.col + dc
        while board.isInBounds(row: r, col: c), case .stone(move.player) = board.cells[r][c] {
            result.append(Move(player: move.player, row: r, col: c))
            r += dr
            c += dc
        }
        // extend negative direction
        r = move.row - dr
        c = move.col - dc
        while board.isInBounds(row: r, col: c), case .stone(move.player) = board.cells[r][c] {
            result.insert(Move(player: move.player, row: r, col: c), at: 0)
            r -= dr
            c -= dc
        }
        return result
    }
}


