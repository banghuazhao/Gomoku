//
// Core types for Gomoku
//

import Foundation

public struct Move: Codable, Equatable, Hashable {
    public let player: Player
    public let row: Int
    public let col: Int
    public init(player: Player, row: Int, col: Int) {
        self.player = player
        self.row = row
        self.col = col
    }
}


