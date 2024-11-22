//
//  TestAppApp.swift
//  TestApp
//
//  Created by Max on 21.11.2024.
//

import SwiftUI

@main
struct TestAppApp: App {
    @StateObject private var navigationState = NavigationState()

    var body: some Scene {
        WindowGroup {
            NavigationStartView()
                .environmentObject(navigationState) 
        }
    }
}
