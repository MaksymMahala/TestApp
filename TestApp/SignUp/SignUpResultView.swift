//
//  SignUpResultView.swift
//  TestApp
//
//  Created by Max on 21.11.2024.
//

import SwiftUI

struct SignUpResultView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: SignUpViewModel
    
    var body: some View {
        VStack {
            if case .failure(let error) = viewModel.registrationResult {
                Image(.resultErrorIcon)
                
                Text(error.localizedDescription)
                    .font(.body)
                    .foregroundColor(.red)
                
                Button {
                    viewModel.registerUser()
                } label: {
                    Text("Try again")
                        .padding()
                        .font(.headline)
                        .foregroundColor(.black)
                        .background(RoundedRectangle(cornerRadius: 20).foregroundColor(.yellow))
                        .padding(.horizontal)
                }
                
            } else if case .success = viewModel.registrationResult {
                Image(.resultSuccessIcon)
                
                Text("User successfully registered")
                    .font(.body)
                    .foregroundColor(.green)
                
                Button {
                    viewModel.cleanAllValues()
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Got it")
                        .padding()
                        .font(.headline)
                        .foregroundColor(.black)
                        .background(RoundedRectangle(cornerRadius: 20).foregroundColor(.yellow))
                        .padding(.horizontal)
                }
            } else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .yellow))
                    .padding()
            }
        }
        .foregroundColor(.primary)
        .font(.title)
    }
}

#Preview {
    SignUpResultView(viewModel: SignUpViewModel())
}

