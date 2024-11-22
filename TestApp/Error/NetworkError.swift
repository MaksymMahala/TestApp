//
//  File.swift
//  TestApp
//
//  Created by Max on 21.11.2024.
//

import Foundation

enum NetworkError: Error {
    case invalidResponse
    case serverError(String)
    case decodingError(String)
    case missingToken
}
