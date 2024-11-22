//
//  RegistrationError.swift
//  TestApp
//
//  Created by Max on 22.11.2024.
//

import Foundation

enum RegistrationError: LocalizedError {
    case invalidToken
    case userAlreadyExists
    case validationFailed([String: [String]])
    case unknown

    var errorDescription: String? {
        switch self {
        case .invalidToken:
            return "The token has expired or is invalid. Please try to fetch a new token."
        case .userAlreadyExists:
            return "A user with this phone or email already exists."
        case .validationFailed(let fails):
            return "Validation failed: \(fails.map { "\($0): \($1.joined(separator: ", "))" }.joined(separator: ", "))"
        case .unknown:
            return "An unknown error occurred. Please try again later."
        }
    }
}
