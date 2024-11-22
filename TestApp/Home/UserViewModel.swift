//
//  User.swift
//  TestApp
//
//  Created by Max on 21.11.2024.
//

import SwiftUI

@MainActor
final class UserViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var currentPage: Int = 1
    @Published var totalPages: Int = 1
    @Published var isLoading: Bool = false
    
    private let userService: UserServiceProtocol
    
    init(userService: UserServiceProtocol = UserService()) {
        self.userService = userService
    }
    
    func fetchUsers() async {
        guard !isLoading, currentPage <= totalPages else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let response = try await userService.fetchUsers(page: currentPage, count: 10)
            self.totalPages = response.totalPages
            self.users.append(contentsOf: response.users)
            self.currentPage += 1
        } catch {
            print("Failed to fetch users: \(error.localizedDescription)")
        }
    }
}
