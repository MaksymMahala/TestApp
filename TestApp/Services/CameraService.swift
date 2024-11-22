//
//  CameraService.swift
//  TestApp
//
//  Created by Max on 21.11.2024.
//

import SwiftUI
import AVFoundation

class CameraService {
    static let shared = CameraService()
    
    func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            // Camera access authorized
            break
        case .denied:
            showPermissionAlert(title: "Camera Access Denied", message: "Please enable camera access in Settings.")
            break
        case .restricted:
            showPermissionAlert(title: "Camera Access Restricted", message: "Camera access is restricted by system settings.")
            break
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { response in
                if response {
                    print("Camera access granted after request.")
                } else {
                    DispatchQueue.main.async {
                        self.showPermissionAlert(title: "Camera Access Denied", message: "Please enable camera access in Settings.")
                    }
                }
            }
        @unknown default:
            break
        }
    }
    
    func showPermissionAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Go to Settings", style: .default) { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)
        
        if let rootViewController = UIApplication.shared.windows.first?.rootViewController {
            rootViewController.present(alertController, animated: true, completion: nil)
        }
    }
}
