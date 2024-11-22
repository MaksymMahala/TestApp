//
//  NoConnectionView.swift
//  TestApp
//
//  Created by Max on 21.11.2024.
//

import SwiftUI

struct NoConnectionView: View {
    @ObservedObject var networkMonitorManager: NetworkMonitorManager
    
    var body: some View {
        VStack {
            Image(.nonConnectionIcon)
            
            Text("There is no internet connection")
                .font(Font.system(size: 20))
                .foregroundStyle(Color.primary)
                .padding()
            
            Button {
                networkMonitorManager.isConnected = false
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
