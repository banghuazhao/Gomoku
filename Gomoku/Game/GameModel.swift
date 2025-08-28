//
// Actor that manages game state and rules
//

import Foundation
import Combine

@MainActor
public final class GameModel: ObservableObject {
    @Published public private(set) var board: Board
    @Published public private(set) var currentPlayer: Player
    @Published public private(set) var isGameOver: Bool
    @Published public private(set) var winner: Player?
    @Published public private(set) var winningLine: [Move]

    private var moves: [Move]
    private var redoStack: [Move]
    private let rules = RulesEngine()

    // AI
    public var isSinglePlayer: Bool = false
    public var aiPlaysAs: Player = .white
    public var difficulty: AIDifficulty = .medium
    private var aiTask: Task<Void, Never>?

    public init(boardSize: Int = 15, starting: Player = .black) {
        self.board = Board(size: boardSize)
        self.currentPlayer = starting
        self.isGameOver = false
        self.winner = nil
        self.winningLine = []
        self.moves = []
        self.redoStack = []
    }

    public func configureSinglePlayer(enabled: Bool, aiAs player: Player = .white, difficulty: AIDifficulty = .medium) {
        self.isSinglePlayer = enabled
        self.aiPlaysAs = player
        self.difficulty = difficulty
        maybeTriggerAIMove()
    }

    public func reset(boardSize: Int? = nil, starting: Player = .black) {
        self.board = Board(size: boardSize ?? board.size)
        self.currentPlayer = starting
        self.isGameOver = false
        self.winner = nil
        self.winningLine = []
        self.moves.removeAll()
        self.redoStack.removeAll()
        aiTask?.cancel()
        maybeTriggerAIMove()
    }

    public func placeStone(row: Int, col: Int) -> Bool {
        guard !isGameOver else { return false }
        let move = Move(player: currentPlayer, row: row, col: col)
        guard rules.validatePlacement(board: board, move: move) else { return false }
        var mutableBoard = board
        guard mutableBoard.place(move) else { return false }
        board = mutableBoard
        moves.append(move)
        redoStack.removeAll()

        let resolution = rules.evaluateBoardAfterMove(board: board, lastMove: move)
        switch resolution {
        case .ongoing:
            currentPlayer = currentPlayer.opponent
            maybeTriggerAIMove()
        case .draw:
            isGameOver = true
            winner = nil
            winningLine = []
        case .win(let result):
            isGameOver = true
            winner = result.winner
            winningLine = result.line
        }
        return true
    }

    @discardableResult
    public func undo() -> Bool {
        guard let last = moves.popLast() else { return false }
        board.clear(atRow: last.row, col: last.col)
        redoStack.append(last)
        isGameOver = false
        winner = nil
        winningLine = []
        currentPlayer = last.player
        aiTask?.cancel()
        return true
    }

    public func redo() -> Bool {
        guard let move = redoStack.popLast() else { return false }
        return placeStone(row: move.row, col: move.col)
    }

    public func history() -> [Move] {
        return moves
    }

    private func maybeTriggerAIMove() {
        guard isSinglePlayer, !isGameOver, currentPlayer == aiPlaysAs else { return }
        aiTask?.cancel()
        let snapshot = board
        let aiPlayer = currentPlayer
        let diff = difficulty
        aiTask = Task { [weak self] in
            guard let self = self else { return }
            // small delay for UX
            try? await Task.sleep(nanoseconds: 250_000_000)
            let choice = AIMoveGenerator.nextMove(for: snapshot, player: aiPlayer, difficulty: diff)
            await MainActor.run {
                if let m = choice {
                    _ = self.placeStone(row: m.row, col: m.col)
                }
            }
        }
    }
}


