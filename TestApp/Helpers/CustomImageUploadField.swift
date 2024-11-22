//
//  C.swift
//  TestApp
//
//  Created by Max on 21.11.2024.
//

import SwiftUI

struct CustomImageUploadField: View {
    var title: String
    @Binding var selectedImage: UIImage?
    var isValidate: Bool
    var errorMessage: String
    @ObservedObject var viewModel: SignUpViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(title)
                    .foregroundStyle(isValidate ? Color.red : Color.gray.opacity(0.7))
                
                Spacer()
                
                Button {
                    viewModel.cameraService.checkCameraPermission()
                    viewModel.showImagePickerOptions()
                } label: {
                    Text("Upload")
                        .font(.headline)
                        .foregroundStyle(Color.blue)
                }
            }
            .padding()
            .frame(height: 66)
            .overlay {
                Rectangle()
                    .strokeBorder(isValidate ? Color.red : Color.gray.opacity(0.6), lineWidth: 1)
                    .padding(.vertical, 8)
            }
            .padding(.horizontal)
            
            Text(errorMessage)
                .font(.system(size: 10))
                .foregroundStyle(Color.red)
                .padding(.leading, 33)
            
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .padding(.top, 10)
            }
        }
    }
}
