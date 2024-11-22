//
//  UserView.swift
//  TestApp
//
//  Created by Max on 21.11.2024.
//

import SwiftUI

import SwiftUI

struct UsersView: View {
    @StateObject private var viewModel = UserViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.users.isEmpty {
                    NoUsersView(viewModel: viewModel)
                } else {
                    List(viewModel.users, id: \.id) { user in
                        HStack {
                            VStack {
                                AsyncImage(url: URL(string: user.photo)) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                        .clipShape(Circle())
                                        .padding(.top, 10)
                                } placeholder: {
                                    ZStack {
                                        Image(systemName: "person.fill")
                                            .resizable()
                                            .foregroundStyle(Color.privateYellow)
                                            .scaledToFit()
                                            .clipShape(Circle())
                                            .frame(width: 50, height: 50)
                                        ProgressView()
                                    }
                                    .padding(.top, 10)
                                }
                                
                                Spacer()
                            }
                            
                            VStack(alignment: .leading, spacing: 7) {
                                Text(user.name)
                                    .foregroundStyle(Color.primary)
                                    .font(.headline)
                                
                                Text(user.position)
                                    .font(.subheadline)
                                    .foregroundStyle(Color.gray)
                                
                                Text(user.email)
                                    .font(.subheadline)
                                    .foregroundColor(.black.opacity(0.8))
                                
                                Text(user.phone)
                                    .font(.subheadline)
                                    .foregroundStyle(Color.primary)
                            }
                        }
                        .onAppear {
                            if user == viewModel.users.last {
                                Task {
                                    await viewModel.fetchUsers()
                                }
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                    
                    if viewModel.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                }
            }
            .toolbar { toolBar }
            .onAppear {
                Task {
                    await viewModel.fetchUsers()
                }
            }
        }
    }
    
    private var toolBar: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text("Working with GET request")
                .padding()
                .frame(maxWidth: .infinity)
                .background {
                    Rectangle()
                        .foregroundStyle(Color.privateYellow)
                }
                .ignoresSafeArea()
        }
    }
}

#Preview {
    UsersView()
}
