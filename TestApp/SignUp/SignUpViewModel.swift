//
//  SignUpViewModel.swift
//  TestApp
//
//  Created by Max on 21.11.2024.
//

import SwiftUI
import Combine

class SignUpViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var phone: String = ""
    @Published var selectedPosition = 0
    @Published var selectedImage: UIImage? = nil
    @Published var isImagePickerPresented = false
    @Published var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Published var isLoading: Bool = false
    @Published var showResultView: Bool = false
    @Published var registrationResult: RegistrationResultType = .success

    @Published var nameErrorMessage: String = ""
    @Published var emailErrorMessage: String = ""
    @Published var phoneErrorMessage: String = ""
    @Published var imageErrorMessage: String = ""

    @Published var positions: [Positions] = []
    @Published var positionsErrorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()

    let cameraService = CameraService.shared

    private let positionServiceProtocol: PositionServiceProtocol
    private let userRegisterService: UserRegisterService
    
    init(positionServiceProtocol: PositionServiceProtocol = PositionService(), userRegisterService: UserRegisterService = UserRegisterService()) {
        self.positionServiceProtocol = positionServiceProtocol
        self.userRegisterService = userRegisterService
        
        self.loadPositions()
    }
    
    func cleanAllValues() {
        name = ""
        email = ""
        phone = ""
        selectedImage = nil
        
        nameErrorMessage = ""
        emailErrorMessage = ""
        phoneErrorMessage = ""
        imageErrorMessage = ""
    }
    
    private func setupValidationBindings() {
        $name
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .map { self.validateName($0) }
            .assign(to: \.nameErrorMessage, on: self)
            .store(in: &cancellables)

        $email
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .map { self.validateEmail($0) }
            .assign(to: \.emailErrorMessage, on: self)
            .store(in: &cancellables)

        $phone
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .map { self.validatePhone($0) }
            .assign(to: \.phoneErrorMessage, on: self)
            .store(in: &cancellables)

        $selectedImage
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .map { image in
                if let image = image {
                    if let resizedImageData = self.resizeAndCompressImage(selectedImage: image) {
                        return self.validatePhoto(UIImage(data: resizedImageData))
                    } else {
                        return "Failed to process the selected image."
                    }
                } else {
                    return "Please select a photo."
                }
            }
            .assign(to: \.imageErrorMessage, on: self)
            .store(in: &cancellables)
    }

    private func validateName(_ name: String) -> String {
        if name.count < 2 || name.count > 60 {
            return "Name must be between 2 and 60 characters."
        }
        return ""
    }

    private func validateEmail(_ email: String) -> String {
        let regex = try! NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}", options: .caseInsensitive)
        let range = NSRange(location: 0, length: email.utf16.count)
        if regex.firstMatch(in: email, options: [], range: range) == nil {
            return "Please enter a valid email address."
        }
        return ""
    }

    private func validatePhone(_ phone: String) -> String {
        if !phone.hasPrefix("+380") {
            return "Phone number should start with +380."
        }
        
        if phone.count != 13 {
            return "Phone number must be exactly 13 symbols, including +380."
        }
        
        return ""
    }

    private func validatePhoto(_ image: UIImage?) -> String {
        guard let image = image else { return "Please select a photo." }

        if let imageData = image.jpegData(compressionQuality: 0.5), imageData.count > 5_000_000 {
            return "Image size should not exceed 5MB."
        }

        if image.size.width < 70 || image.size.height < 70 {
            return "Image resolution must be at least 70x70px."
        }
        
        if let imageData = image.jpegData(compressionQuality: 0.5),
           let imageSource = CGImageSourceCreateWithData(imageData as CFData, nil) {
            let imageType = CGImageSourceGetType(imageSource) as String?
            if imageType?.hasSuffix("jpeg") == false {
                return "Photo must be a JPG/JPEG image."
            }
        }
        
        return ""
    }
    
    func isValidateImage() -> Bool {
        return imageErrorMessage.isEmpty
    }
    
    func isValidateEmail() -> Bool {
        return emailErrorMessage.isEmpty
    }
    
    func isValidateName() -> Bool {
        return nameErrorMessage.isEmpty
    }
    
    func isValidatePhone() -> Bool {
        return phoneErrorMessage.isEmpty
    }
    
    func isValidate() -> Bool {
        return imageErrorMessage.isEmpty && emailErrorMessage.isEmpty && nameErrorMessage.isEmpty && phoneErrorMessage.isEmpty
    }
    
    func disabled() -> Bool {
        return selectedImage == nil && email.isEmpty && name.isEmpty && phone.isEmpty
    }

    private func resizeAndCompressImage(selectedImage: UIImage) -> Data? {
        let resizedImage = resizeImage(selectedImage) // Resize the image to 80x80
        guard let imageData = resizedImage.jpegData(compressionQuality: 0.3) else {
            imageErrorMessage = "Failed to process the selected image."
            return nil
        }
        
        return imageData
    }

    func registerUser() {
        setupValidationBindings()

        if nameErrorMessage.isEmpty && emailErrorMessage.isEmpty && phoneErrorMessage.isEmpty && imageErrorMessage.isEmpty {
            guard let selectedImage = selectedImage else {
                imageErrorMessage = "Please select your image"
                return
            }
            
            let resizedImage = resizeAndCompressImage(selectedImage: selectedImage)
            
            let user = UserRegister(
                name: name,
                email: email,
                phone: phone,
                positionID: selectedPosition,
                photo: resizedImage ?? Data())
                        
            userRegisterService.registerUser(user) { result in
                switch result {
                case .success(let response):
                    DispatchQueue.main.async {
                        self.registrationResult = .success
                        self.showResultView = true
                        print("Registration successful: \(response)")
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.registrationResult = .failure(error)
                        self.showResultView = true
                        print("Registration failed: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    func resizeImage(_ image: UIImage, targetSize: CGSize = CGSize(width: 80, height: 80)) -> UIImage {
        let aspectRatio = image.size.width / image.size.height
        var newSize: CGSize
        
        if aspectRatio > 1 {
            newSize = CGSize(width: targetSize.width, height: targetSize.width / aspectRatio)
        } else {
            newSize = CGSize(width: targetSize.height * aspectRatio, height: targetSize.height)
        }
        
        UIGraphicsBeginImageContextWithOptions(targetSize, false, image.scale)
        let origin = CGPoint(x: (targetSize.width - newSize.width) / 2, y: (targetSize.height - newSize.height) / 2)
        image.draw(in: CGRect(origin: origin, size: newSize))
        
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage ?? image
    }
    
    func showImagePickerOptions() {
        let alert = UIAlertController(title: "Choose how you want to add a photo", message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
                self.sourceType = .camera
                self.isImagePickerPresented.toggle()
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.sourceType = .photoLibrary
            self.isImagePickerPresented.toggle()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if let rootViewController = UIApplication.shared.windows.first?.rootViewController {
            rootViewController.present(alert, animated: true, completion: nil)
        }
    }
    
    func loadPositions() {
        positionServiceProtocol.fetchPositions { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let positions):
                    self?.positions = positions
                    self?.positionsErrorMessage = nil
                case .failure(let error):
                    self?.positions = []
                    self?.positionsErrorMessage = error.localizedDescription
                }
            }
        }
    }
}
