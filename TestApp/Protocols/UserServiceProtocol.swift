//
//  user.swift
//  TestApp
//
//  Created by Max on 21.11.2024.
//

import Foundation

protocol UserServiceProtocol {
    func fetchUsers(page: Int, count: Int) async throws -> UsersResponse
}

protocol UserRegisterServiceProtocol {
    func registerUser(_ user: UserRegister, completion: @escaping (Result<UserRegistrationResponse, NetworkError>) -> Void)
}
