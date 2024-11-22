//
//  TabBarItem.swift
//  TestApp
//
//  Created by Max on 22.11.2024.
//

import SwiftUI

struct TabBarItem: View {
    let icon: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        VStack {
            Image(icon)
        }
        .padding()
        .onTapGesture {
            action()
        }
    }
}
