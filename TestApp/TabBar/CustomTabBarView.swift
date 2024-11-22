//
//  ContentView.swift
//  TestApp
//
//  Created by Max on 21.11.2024.
//

import SwiftUI

struct CustomTabBarView: View {
    @EnvironmentObject var navigationState: NavigationState
    @State private var selectedTab: Tab = .users

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                if selectedTab == .users {
                    UsersView()
                } else {
                    SignUpView()
                }
                
                Spacer()

                HStack {
                    TabBarItem(
                        icon: selectedTab == .users ? "usersSelected_Icon" : "usersUnselected_Icon",
                        isSelected: selectedTab == .users
                    ) {
                        selectedTab = .users
                    }
                    
                    Spacer()
                    
                    TabBarItem(
                        icon: selectedTab == .signUp ? "signUpSelected_Icon" : "signUpUnselected_Icon",
                        isSelected: selectedTab == .signUp
                    ) {
                        selectedTab = .signUp
                    }
                }
                .padding(5)
                .background(Color.gray.opacity(0.3))
            }
        }
    }
}

#Preview {
    CustomTabBarView()
}
