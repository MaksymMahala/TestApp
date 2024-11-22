//
//  PostionProtocol.swift
//  TestApp
//
//  Created by Max on 22.11.2024.
//

import Foundation

protocol PositionServiceProtocol {
    func fetchPositions(completion: @escaping (Result<[Positions], Error>) -> Void)
}
