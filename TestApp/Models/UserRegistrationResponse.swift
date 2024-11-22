//
//  а.swift
//  TestApp
//
//  Created by Max on 21.11.2024.
//

import Foundation

struct UserRegistrationResponse: Codable {
    let success: Bool
    let userID: Int?
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case success, message, userID = "user_id"
    }
}

struct UserRegister: Codable {
    let name: String
    let email: String
    let phone: String
    let positionID: Int
    let photo: Data
}
