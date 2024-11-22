//
//  SignUpView.swift
//  TestApp
//
//  Created by Max on 21.11.2024.
//

import SwiftUI

struct SignUpView: View {
    @StateObject private var viewModel = SignUpViewModel()

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    fields
                    
                    position
                    
                    uploadPhoto
                    
                    signUpButton
                }
            }
            .toolbar {
                toolBar
            }
            .navigationDestination(isPresented: $viewModel.showResultView) {
                SignUpResultView(viewModel: viewModel)
            }
            .fullScreenCover(isPresented: $viewModel.isImagePickerPresented) {
                ImagePicker(isImagePickerPresented: $viewModel.isImagePickerPresented, selectedImage: $viewModel.selectedImage, sourceType: viewModel.sourceType)
                    .ignoresSafeArea()
            }
        }
    }
    
    private var toolBar: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text("Working with POST request")
                .padding()
                .frame(maxWidth: .infinity)
                .background {
                    Rectangle()
                        .foregroundStyle(Color.privateYellow)
                }
                .ignoresSafeArea()
        }
    }
    
    private var fields: some View {
        VStack {
            CustomTextField(
                title: "Your name",
                text: $viewModel.name,
                errorMessage: viewModel.nameErrorMessage,
                isValidate: !viewModel.isValidateName()
            )
            
            CustomEmailTextField(
                title: "Email",
                text: $viewModel.email,
                errorMessage: viewModel.emailErrorMessage,
                isValidate: !viewModel.isValidateEmail()
            )
            
            CustomTextField(
                title: "Phone",
                text: $viewModel.phone,
                errorMessage: viewModel.phoneErrorMessage,
                isValidate: !viewModel.isValidatePhone(),
                placeholderText: "+38 (XXX) XXX - XX - XX"
            )
        }
    }
    
    private var position: some View {
        VStack(alignment: .leading) {
            Text("Select your position")
                .font(.title2)
                .foregroundStyle(Color.primary)
                .padding(.top, 30)
                .padding(.horizontal)
            
            VStack {
                ForEach(viewModel.positions, id: \.id) { position in
                    HStack {
                        if viewModel.selectedPosition == position.id {
                            ZStack {
                                Circle()
                                    .foregroundStyle(Color.cyan)
                                    .frame(width: 15, height: 15)
                                Circle()
                                    .foregroundStyle(Color.white)
                                    .frame(width: 6, height: 6)
                            }
                        } else {
                            Circle()
                                .stroke(Color.gray)
                                .frame(width: 15, height: 15)
                        }
                        Button {
                            viewModel.selectedPosition = position.id
                        } label: {
                            Text(position.name)
                                .font(.system(size: 16))
                                .padding(12)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundColor(.primary)
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    private var uploadPhoto: some View {
        ZStack {
            if let selectedImage = viewModel.selectedImage {
                HStack {
                    Spacer()
                    
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 140, height: 140)
                        .clipShape(Circle())
                        .padding()
                    
                    Spacer()
                }
            } else {
                CustomImageUploadField(
                    title: "Upload your photo",
                    selectedImage: $viewModel.selectedImage,
                    isValidate: !viewModel.isValidateImage(),
                    errorMessage: viewModel.imageErrorMessage,
                    viewModel: viewModel
                )
            }
        }
    }
    
    private var signUpButton: some View {
        HStack {
            Spacer()
            
            Button {
                viewModel.registerUser()
            } label: {
                Text("Sign up")
                    .foregroundStyle(viewModel.isValidate() && !viewModel.disabled() ? Color.white : Color.gray)
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 25)
                            .frame(width: 140, height: 48)
                            .foregroundStyle(viewModel.isValidate() && !viewModel.disabled() ? Color.privateYellow : Color(uiColor: UIColor.lightGray).opacity(0.5))
                    }
                    .disabled(viewModel.disabled())
            }
            
            Spacer()
        }
    }
}

#Preview {
    SignUpView()
}
