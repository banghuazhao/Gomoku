//
// Simple AI engine for Gomoku
//

import Foundation

public enum AIDifficulty: String, CaseIterable, Codable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
}

struct AIMoveGenerator {
    static func nextMove(for board: Board, player: Player, difficulty: AIDifficulty) -> Move? {
        let candidates = candidatePositions(board: board)
        if candidates.isEmpty { return nil }
        
        // Immediate win or block checks first (used for all levels)
        if let win = immediateWinningMove(board: board, player: player, candidates: candidates) {
            return win
        }
        if let block = immediateWinningMove(board: board, player: player.opponent, candidates: candidates) {
            return Move(player: player, row: block.row, col: block.col)
        }
        
        switch difficulty {
        case .easy:
            return candidates.randomElement().map { Move(player: player, row: $0.row, col: $0.col) }
        case .medium:
            return bestHeuristicMove(board: board, player: player, candidates: candidates)
        case .hard:
            return minimaxBestMove(board: board, player: player, candidates: candidates, depth: 2)
        }
    }
    
    // MARK: - Candidate generation (near existing stones)
    private static func candidatePositions(board: Board) -> [(row: Int, col: Int)] {
        var result: Set<Int> = []
        let size = board.size
        let radius = 2
        var hasStone = false
        for r in 0..<size {
            for c in 0..<size {
                if case .stone = board.cells[r][c] { hasStone = true }
            }
        }
        if !hasStone { return [(row: size/2, col: size/2)] }
        for r in 0..<size {
            for c in 0..<size {
                if case .empty = board.cells[r][c] {
                    // Check neighborhood for any stone
                    var near = false
                    loop: for dr in -radius...radius {
                        for dc in -radius...radius {
                            if dr == 0 && dc == 0 { continue }
                            let nr = r + dr, nc = c + dc
                            if nr >= 0 && nr < size && nc >= 0 && nc < size {
                                if case .stone = board.cells[nr][nc] { near = true; break loop }
                            }
                        }
                    }
                    if near { result.insert(r * 100 + c) }
                }
            }
        }
        return result.map { ($0 / 100, $0 % 100) }
    }
    
    // MARK: - Immediate win
    private static func immediateWinningMove(board: Board, player: Player, candidates: [(row: Int, col: Int)]) -> Move? {
        var boardCopy = board
        let rules = RulesEngine()
        for cand in candidates {
            let move = Move(player: player, row: cand.row, col: cand.col)
            boardCopy = board
            if boardCopy.place(move) {
                let res = rules.evaluateBoardAfterMove(board: boardCopy, lastMove: move)
                if case .win = res { return move }
            }
        }
        return nil
    }
    
    // MARK: - Heuristic
    private static func bestHeuristicMove(board: Board, player: Player, candidates: [(row: Int, col: Int)]) -> Move? {
        var bestScore = Int.min
        var best: (row: Int, col: Int)?
        for cand in candidates {
            let score = evaluatePlacement(board: board, player: player, row: cand.row, col: cand.col)
            if score > bestScore {
                bestScore = score
                best = cand
            }
        }
        if let best = best { return Move(player: player, row: best.row, col: best.col) }
        return candidates.randomElement().map { Move(player: player, row: $0.row, col: $0.col) }
    }
    
    private static func evaluatePlacement(board: Board, player: Player, row: Int, col: Int) -> Int {
        var b = board
        guard b.place(Move(player: player, row: row, col: col)) else { return Int.min / 2 }
        return evaluateBoardHeuristic(board: b, player: player) - evaluateBoardHeuristic(board: b, player: player.opponent)
    }
    
    private static func evaluateBoardHeuristic(board: Board, player: Player) -> Int {
        // Score lines: five=100000, open four=10000, closed four=2000, open three=500, two=50
        let dirs = [(0,1),(1,0),(1,1),(1,-1)]
        var score = 0
        for r in 0..<board.size {
            for c in 0..<board.size {
                if case .stone(player) = board.cells[r][c] {
                    for (dr,dc) in dirs {
                        var count = 1
                        var openEnds = 0
                        var rr = r + dr, cc = c + dc
                        while rr >= 0 && rr < board.size && cc >= 0 && cc < board.size, case .stone(player) = board.cells[rr][cc] {
                            count += 1
                            rr += dr; cc += dc
                        }
                        if rr >= 0 && rr < board.size && cc >= 0 && cc < board.size, case .empty = board.cells[rr][cc] { openEnds += 1 }
                        rr = r - dr; cc = c - dc
                        while rr >= 0 && rr < board.size && cc >= 0 && cc < board.size, case .stone(player) = board.cells[rr][cc] {
                            count += 1
                            rr -= dr; cc -= dc
                        }
                        if rr >= 0 && rr < board.size && cc >= 0 && cc < board.size, case .empty = board.cells[rr][cc] { openEnds += 1 }
                        
                        switch (count, openEnds) {
                        case (5, _): score += 100000
                        case (4, 2): score += 10000
                        case (4, 1): score += 2000
                        case (3, 2): score += 500
                        case (3, 1): score += 120
                        case (2, 2): score += 50
                        default: break
                        }
                    }
                }
            }
        }
        return score
    }
    
    // MARK: - Minimax (shallow)
    private static func minimaxBestMove(board: Board, player: Player, candidates: [(row: Int, col: Int)], depth: Int) -> Move? {
        var bestScore = Int.min
        var best: (row: Int, col: Int)?
        for cand in candidates {
            var b = board
            _ = b.place(Move(player: player, row: cand.row, col: cand.col))
            let score = minimax(board: b, player: player, current: player.opponent, depth: depth - 1, alpha: Int.min/4, beta: Int.max/4)
            if score > bestScore {
                bestScore = score
                best = cand
            }
        }
        if let best = best { return Move(player: player, row: best.row, col: best.col) }
        return bestHeuristicMove(board: board, player: player, candidates: candidates)
    }
    
    private static func minimax(board: Board, player: Player, current: Player, depth: Int, alpha: Int, beta: Int) -> Int {
        let rules = RulesEngine()
        // quick terminal check by scanning last move is not available; use heuristic when depth==0
        if depth == 0 { return evaluateBoardHeuristic(board: board, player: player) - evaluateBoardHeuristic(board: board, player: player.opponent) }
        
        var alphaVar = alpha
        var betaVar = beta
        let candidates = candidatePositions(board: board)
        if current == player {
            var maxEval = Int.min
            for cand in candidates {
                var b = board
                let move = Move(player: current, row: cand.row, col: cand.col)
                _ = b.place(move)
                // simple early stop if win
                if case .win = rules.evaluateBoardAfterMove(board: b, lastMove: move) { return 100000 }
                let eval = minimax(board: b, player: player, current: current.opponent, depth: depth - 1, alpha: alphaVar, beta: betaVar)
                maxEval = max(maxEval, eval)
                alphaVar = max(alphaVar, eval)
                if betaVar <= alphaVar { break }
            }
            return maxEval
        } else {
            var minEval = Int.max
            for cand in candidates {
                var b = board
                let move = Move(player: current, row: cand.row, col: cand.col)
                _ = b.place(move)
                if case .win = rules.evaluateBoardAfterMove(board: b, lastMove: move) { return -100000 }
                let eval = minimax(board: b, player: player, current: current.opponent, depth: depth - 1, alpha: alphaVar, beta: betaVar)
                minEval = min(minEval, eval)
                betaVar = min(betaVar, eval)
                if betaVar <= alphaVar { break }
            }
            return minEval
        }
    }
}
