//
//  Ex.swift
//  TestApp
//
//  Created by Max on 21.11.2024.
//

import Foundation

extension User: Equatable {
    static func ==(lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
}

extension String {
    func lowercasingFirstLetter() -> String {
        return prefix(1).lowercased() + dropFirst()
    }
}
