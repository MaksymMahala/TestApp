//
//  NoUsersView.swift
//  TestApp
//
//  Created by Max on 21.11.2024.
//

import SwiftUI

struct NoUsersView: View {
    @ObservedObject var viewModel: UserViewModel

    var body: some View {
        VStack {
            Image(.successIcon)
            
            Text("There is no internet connection")
                .font(Font.system(size: 20))
                .foregroundStyle(Color.primary)
                .padding()
            
            Button {
                Task {
                    await viewModel.fetchUsers()
                }
            } label: {
                Text("Try again")
                    .foregroundStyle(Color.black)
                    .font(Font.system(size: 18).bold())
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 24)
                            .foregroundStyle(Color.privateYellow)
                    }
                    .padding(.horizontal)
            }

        }
    }
}

#Preview {
    NoUsersView(viewModel: UserViewModel())
}
