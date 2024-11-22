//
//  users.swift
//  TestApp
//
//  Created by Max on 21.11.2024.
//

import Foundation

struct UsersResponse: Codable {
    let success: Bool
    let totalPages: Int
    let totalUsers: Int
    let count: Int
    let page: Int
    let links: Links
    let users: [User]
    
    enum CodingKeys: String, CodingKey {
        case success, count, page, links, users
        case totalPages = "total_pages"
        case totalUsers = "total_users"
    }
}

struct User: Codable {
    let id: Int
    let name: String
    let email: String
    let phone: String
    let position: String
    let positionID: Int
    let registrationTimestamp: Int
    let photo: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, email, phone, position, photo
        case positionID = "position_id"
        case registrationTimestamp = "registration_timestamp"
    }
}
