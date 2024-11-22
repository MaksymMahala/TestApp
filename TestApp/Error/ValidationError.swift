//
//  ValidationError.swift
//  TestApp
//
//  Created by Max on 22.11.2024.
//

import Foundation

enum ValidationError: Error {
    case invalidName
    case invalidEmail
    case invalidPhone
    case invalidPosition
    case invalidPhoto
}
