//
//  NavigationStartView.swift
//  TestApp
//
//  Created by Max on 22.11.2024.
//

import SwiftUI

struct NavigationStartView: View {
    @StateObject private var navigationState = NavigationState()

    var body: some View {
        if navigationState.isLaunched {
            CustomTabBarView()
                .environmentObject(navigationState)
        } else {
            LaunchView()
                .environmentObject(navigationState)
        }
    }
}

class NavigationState: ObservableObject {
    @Published var isLaunched = false
}
