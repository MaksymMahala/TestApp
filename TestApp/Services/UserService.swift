//
//  UserService.swift
//  TestApp
//
//  Created by Max on 21.11.2024.
//

import SwiftUI

final class UserService: UserServiceProtocol {
    private let baseURL = "https://frontend-test-assignment-api.abz.agency/api/v1/users"
    
    func fetchUsers(page: Int, count: Int) async throws -> UsersResponse {
        guard let url = URL(string: "\(baseURL)?page=\(page)&count=\(count)") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(UsersResponse.self, from: data)
    }
}
