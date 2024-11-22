//
//  paginationLinks.swift
//  TestApp
//
//  Created by Max on 21.11.2024.
//

import Foundation

struct Links: Codable {
    let nextURL: String?
    let prevURL: String?

    enum CodingKeys: String, CodingKey {
        case nextURL = "next_url"
        case prevURL = "prev_url"
    }
}
