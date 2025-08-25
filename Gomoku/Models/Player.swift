//
// Created by Banghua Zhao on 25/08/2025
// Copyright Apps Bay Limited. All rights reserved.
//
  

import Foundation

public enum Player: String, Codable, Equatable {
    case black
    case white

    public var opponent: Player {
        switch self {
        case .black: return .white
        case .white: return .black
        }
    }
}
