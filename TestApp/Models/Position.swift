//
//  Position.swift
//  TestApp
//
//  Created by Max on 22.11.2024.
//

import Foundation

struct Positions: Codable {
    let id: Int
    let name: String
}

struct PositionResponse: Codable {
    let success: Bool
    let positions: [Positions]?
    let message: String?
}
