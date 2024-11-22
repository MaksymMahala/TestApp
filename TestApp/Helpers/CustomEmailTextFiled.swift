//
//  CustomEmailTextFiled.swift
//  TestApp
//
//  Created by Max on 22.11.2024.
//

import SwiftUI

struct CustomEmailTextField: View {
    var title: String
    @Binding var text: String
    var errorMessage: String
    var isValidate: Bool
    var placeholderText: String? = nil
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .leading) {
                if text.isEmpty {
                    Text(title)
                        .font(.system(size: 16))
                        .foregroundStyle(isValidate ? Color.red : Color.gray.opacity(0.7))
                        .padding(.leading, 33)
                }
                
                TextField("", text: Binding(
                    get: { text },
                    set: { newValue in
                        text = newValue.lowercasingFirstLetter()
                    }
                ))
                .padding()
                .frame(height: 66)
                .foregroundStyle(isValidate ? Color.red : Color.black)
                .background(
                    Rectangle()
                        .strokeBorder(isValidate ? Color.red : Color.gray.opacity(0.6), lineWidth: 1)
                        .padding(.vertical, 8)
                )
                .cornerRadius(10)
                .padding(.horizontal)
            }
            
            Text(errorMessage)
                .font(.system(size: 10))
                .foregroundStyle(Color.red)
                .padding(.leading, 33)
            
            if let placeholder = placeholderText, text.isEmpty {
                Text(placeholder)
                    .font(.system(size: 13))
                    .foregroundStyle(Color.gray)
                    .padding(.leading, 33)
            }
        }
    }
}
