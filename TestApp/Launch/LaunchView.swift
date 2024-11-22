//
//  LaunchView.swift
//  TestApp
//
//  Created by Max on 21.11.2024.
//

import SwiftUI

struct LaunchView: View {
    @EnvironmentObject var navigationState: NavigationState
    @StateObject private var networkMonitorManager = NetworkMonitorManager()

    var body: some View {
        NavigationStack {
            ZStack {
                if networkMonitorManager.isConnected {
                    Color.privateYellow
                        .ignoresSafeArea()
                    
                    VStack {
                        Image(.launchCatIcon)
                        
                        Text("TESTTASK")
                            .foregroundStyle(Color.primary)
                            .font(.title)
                    }
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            navigationState.isLaunched = true
                        }
                    }
                } else {
                    NoConnectionView(networkMonitorManager: networkMonitorManager)
                }
            }
        }
    }
}

#Preview {
    LaunchView()
}
