//
// Simple AI engine for Gomoku
//

import Foundation

public enum AIDifficulty: String, CaseIterable, Codable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
    case superHard = "Super Hard"
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
        case .superHard:
            return superHardBestMove(board: board, player: player, candidates: candidates)
        }
    }
    
    // MARK: - Candidate generation (near existing stones)
    private static func candidatePositions(board: Board) -> [(row: Int, col: Int)] {
        var result: Set<Int> = []
        let size = board.size
        var radius = 2
        var hasStone = false
        var stones = 0
        for r in 0..<size {
            for c in 0..<size {
                if case .stone = board.cells[r][c] {
                    hasStone = true
                    stones += 1
                }
            }
        }
        if stones <= 1 { radius = 1 }
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
                if case .stone(player, _) = board.cells[r][c] {
                    for (dr,dc) in dirs {
                        var count = 1
                        var openEnds = 0
                        var rr = r + dr, cc = c + dc
                        while rr >= 0 && rr < board.size && cc >= 0 && cc < board.size, case .stone(player, _) = board.cells[rr][cc] {
                            count += 1
                            rr += dr; cc += dc
                        }
                        if rr >= 0 && rr < board.size && cc >= 0 && cc < board.size, case .empty = board.cells[rr][cc] { openEnds += 1 }
                        rr = r - dr; cc = c - dc
                        while rr >= 0 && rr < board.size && cc >= 0 && cc < board.size, case .stone(player, _) = board.cells[rr][cc] {
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

    // MARK: - Super Hard: Negamax + Alpha-Beta + Iterative Deepening + TT
    private struct TTEntry {
        enum Bound { case exact, lower, upper }
        let value: Int
        let depth: Int
        let bound: Bound
        let bestMove: (row: Int, col: Int)?
    }

    private static func superHardBestMove(board: Board, player: Player, candidates: [(row: Int, col: Int)], timeLimitMs: Int = 400) -> Move? {
        // Immediate win/block already handled by caller
        var ordered = orderCandidates(board: board, player: player, candidates: candidates)
        // Iterative deepening
        let deadline = DispatchTime.now() + .milliseconds(timeLimitMs)
        var tt: [UInt64: TTEntry] = [:]
        var best: (row: Int, col: Int)? = ordered.first
        var bestScore = Int.min
        var depth = 2
        while depth <= 6 { // practical cap
            var timedOut = false
            bestScore = Int.min
            var localBest: (row: Int, col: Int)? = nil
            for move in ordered {
                if DispatchTime.now() >= deadline { timedOut = true; break }
                var b = board
                _ = b.place(Move(player: player, row: move.row, col: move.col))
                let score = -negamax(board: b, playerToMaximize: player, currentPlayer: player.opponent, depth: depth - 1, alpha: -1_000_000_000, beta: 1_000_000_000, tt: &tt, deadline: deadline)
                if score > bestScore {
                    bestScore = score
                    localBest = move
                }
            }
            if let lb = localBest { best = lb }
            if timedOut { break }
            // Reorder by TT/last best for next iteration (move ordering)
            if let bmv = best {
                ordered.sort { lhs, rhs in
                    if lhs.row == bmv.row && lhs.col == bmv.col { return true }
                    if rhs.row == bmv.row && rhs.col == bmv.col { return false }
                    let sl = staticHeuristic(board: board, player: player, row: lhs.row, col: lhs.col)
                    let sr = staticHeuristic(board: board, player: player, row: rhs.row, col: rhs.col)
                    return sl > sr
                }
            }
            depth += 1
        }
        if let best = best { return Move(player: player, row: best.row, col: best.col) }
        return candidates.randomElement().map { Move(player: player, row: $0.row, col: $0.col) }
    }

    private static func negamax(board: Board, playerToMaximize: Player, currentPlayer: Player, depth: Int, alpha: Int, beta: Int, tt: inout [UInt64: TTEntry], deadline: DispatchTime) -> Int {
        if DispatchTime.now() >= deadline { return evaluateStatic(board: board, player: playerToMaximize) }
        let rules = RulesEngine()
        // Terminal check by quick scan of last move is unavailable; use evaluation at depth==0
        if depth == 0 { return evaluateStatic(board: board, player: playerToMaximize) }

        let hash = zobristHash(board: board)
        if let entry = tt[hash], entry.depth >= depth {
            switch entry.bound {
            case .exact: return entry.value
            case .lower: if entry.value > beta { return entry.value }
            case .upper: if entry.value < alpha { return entry.value }
            }
        }

        var alphaVar = alpha
        let alphaStart = alpha
        var bestValue = Int.min
        var bestMove: (row: Int, col: Int)? = nil
        // Move ordering: immediate tactical, then heuristic
        var candidates = candidatePositions(board: board)
        if candidates.isEmpty { return 0 }
        candidates = orderCandidates(board: board, player: currentPlayer, candidates: candidates)

        var exploredAny = false
        for cand in candidates {
            if DispatchTime.now() >= deadline { break }
            var b = board
            let move = Move(player: currentPlayer, row: cand.row, col: cand.col)
            _ = b.place(move)
            // Early win pruning
            if case .win = rules.evaluateBoardAfterMove(board: b, lastMove: move) {
                return currentPlayer == playerToMaximize ? 100000 : -100000
            }
            let score = -negamax(board: b, playerToMaximize: playerToMaximize, currentPlayer: currentPlayer.opponent, depth: depth - 1, alpha: -beta, beta: -alphaVar, tt: &tt, deadline: deadline)
            if score > bestValue {
                bestValue = score
                bestMove = cand
            }
            if bestValue > alphaVar { alphaVar = bestValue }
            if alphaVar >= beta { break }
            exploredAny = true
        }

        if !exploredAny {
            return evaluateStatic(board: board, player: playerToMaximize)
        }

        // Store in TT
        let entryBound: TTEntry.Bound
        if bestValue <= alphaStart { entryBound = .upper }
        else if bestValue >= beta { entryBound = .lower }
        else { entryBound = .exact }
        tt[hash] = TTEntry(value: bestValue, depth: depth, bound: entryBound, bestMove: bestMove)
        return bestValue
    }

    // MARK: - Move Ordering and Heuristics
    private static func orderCandidates(board: Board, player: Player, candidates: [(row: Int, col: Int)]) -> [(row: Int, col: Int)] {
        // Score each candidate using static pattern heuristic and distance to center
        let center = Double(board.size - 1) / 2.0
        return candidates.sorted { a, b in
            let sa = staticHeuristic(board: board, player: player, row: a.row, col: a.col) + centerBias(row: a.row, col: a.col, center: center)
            let sb = staticHeuristic(board: board, player: player, row: b.row, col: b.col) + centerBias(row: b.row, col: b.col, center: center)
            return sa > sb
        }
    }

    private static func centerBias(row: Int, col: Int, center: Double) -> Int {
        let dr = Double(row) - center
        let dc = Double(col) - center
        let dist2 = dr*dr + dc*dc
        // closer to center slightly preferred
        return Int(50.0 / (1.0 + dist2))
    }

    private static func staticHeuristic(board: Board, player: Player, row: Int, col: Int) -> Int {
        var b = board
        if !b.place(Move(player: player, row: row, col: col)) { return Int.min/4 }
        // Mix offensive and defensive pressure
        let off = evaluatePatterns(board: b, player: player)
        let def = evaluatePatterns(board: b, player: player.opponent)
        return off * 1 - def
    }

    private static func evaluateStatic(board: Board, player: Player) -> Int {
        // More granular scoring than the medium/hard evaluator
        let myScore = evaluatePatterns(board: board, player: player)
        let oppScore = evaluatePatterns(board: board, player: player.opponent)
        return myScore - oppScore
    }

    // Pattern-based evaluator: counts lines with open/closed ends and broken-fours
    private static func evaluatePatterns(board: Board, player: Player) -> Int {
        let directions = [(0,1),(1,0),(1,1),(1,-1)]
        var score = 0
        for r in 0..<board.size {
            for c in 0..<board.size {
                if case .stone(player, _) = board.cells[r][c] {
                    for (dr,dc) in directions {
                        // Count contiguous in both directions and openness
                        var count = 1
                        var openEnds = 0
                        var rr = r + dr, cc = c + dc
                        while rr >= 0 && rr < board.size && cc >= 0 && cc < board.size, case .stone(player, _) = board.cells[rr][cc] {
                            count += 1
                            rr += dr; cc += dc
                        }
                        if rr >= 0 && rr < board.size && cc >= 0 && cc < board.size {
                            if case .empty = board.cells[rr][cc] { openEnds += 1 }
                        }
                        rr = r - dr; cc = c - dc
                        while rr >= 0 && rr < board.size && cc >= 0 && cc < board.size, case .stone(player, _) = board.cells[rr][cc] {
                            count += 1
                            rr -= dr; cc -= dc
                        }
                        if rr >= 0 && rr < board.size && cc >= 0 && cc < board.size {
                            if case .empty = board.cells[rr][cc] { openEnds += 1 }
                        }

                        // Broken four: X X _ X X shape detection (one gap)
                        let brokenFour = detectBrokenFour(board: board, player: player, row: r, col: c, dr: dr, dc: dc)

                        switch (count, openEnds, brokenFour) {
                        case (5, _, _): score += 1_000_000
                        case (4, 2, _): score += 100_000 // open four
                        case (4, 1, _): score += 20_000 // closed four
                        case (_, _, true): score += 30_000 // broken four (threatening)
                        case (3, 2, _): score += 5_000  // open three
                        case (3, 1, _): score += 1_000  // closed three
                        case (2, 2, _): score += 300
                        case (2, 1, _): score += 80
                        default: break
                        }
                    }
                }
            }
        }
        return score
    }

    private static func detectBrokenFour(board: Board, player: Player, row: Int, col: Int, dr: Int, dc: Int) -> Bool {
        // Scan window of length 6 centered around (row,col) in (dr,dc) to find patterns like XX_XX
        var stones: [Int] = [] // 1=mine, 0=empty, -1=other
        stones.reserveCapacity(6)
        let startOffset = -2
        for i in 0..<6 {
            let r = row + (startOffset + i) * dr
            let c = col + (startOffset + i) * dc
            if r < 0 || r >= board.size || c < 0 || c >= board.size {
                stones.append(-2) // out of bounds sentinel
                continue
            }
            switch board.cells[r][c] {
            case .empty: stones.append(0)
            case .stone(player, _): stones.append(1)
            default: stones.append(-1)
            }
        }
        // Look for sequences 1,1,0,1,1 within bounds (ignore -2)
        for i in 0..<(stones.count - 4) {
            let window = Array(stones[i..<(i+5)])
            if window.contains(-2) { continue }
            if window == [1,1,0,1,1] { return true }
        }
        return false
    }

    // MARK: - Zobrist Hashing
    private static func zobristHash(board: Board) -> UInt64 {
        // Deterministic pseudo-random numbers
        struct RNG { static var state: UInt64 = 0x9E3779B97F4A7C15 }
        func next() -> UInt64 {
            RNG.state &+= 0x9E3779B97F4A7C15
            var x = RNG.state
            x = (x ^ (x >> 30)) &* 0xBF58476D1CE4E5B9
            x = (x ^ (x >> 27)) &* 0x94D049BB133111EB
            return x ^ (x >> 31)
        }
        // Cache table locally per call to avoid static init costs
        var table: [[UInt64]] = Array(repeating: Array(repeating: 0, count: 2), count: board.size * board.size)
        for i in 0..<(board.size * board.size) {
            table[i][0] = next()
            table[i][1] = next()
        }
        var h: UInt64 = 1469598103934665603 // FNV offset basis
        for r in 0..<board.size {
            for c in 0..<board.size {
                let idx = r * board.size + c
                switch board.cells[r][c] {
                case .stone(.black, _): h ^= table[idx][0]
                case .stone(.white, _): h ^= table[idx][1]
                default: break
                }
            }
        }
        return h
    }
}
