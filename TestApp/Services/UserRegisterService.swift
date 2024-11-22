//
//  NetworkMonitorManager.swift
//  TestApp
//
//  Created by Max on 21.11.2024.
//

import SwiftUI
import Foundation

final class UserRegisterService: UserRegisterServiceProtocol {
    private let baseURL = "https://frontend-test-assignment-api.abz.agency/api/v1/users"
    private let tokenURL = "https://frontend-test-assignment-api.abz.agency/api/v1/token"

    func fetchToken(completion: @escaping (Result<String, NetworkError>) -> Void) {
        guard let url = URL(string: tokenURL) else {
            completion(.failure(.invalidResponse))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        
        let session = URLSession.shared
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.serverError(error.localizedDescription)))
                return
            }
            
            guard let data = data,
                  let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.invalidResponse))
                return
            }
            
            do {
                let tokenResponse = try JSONDecoder().decode(TokenResponse.self, from: data)
                if tokenResponse.success {
                    DispatchQueue.main.async {
                        completion(.success(tokenResponse.token))
                    }
                } else {
                    completion(.failure(.serverError("Failed to fetch token.")))
                }
            } catch {
                completion(.failure(.decodingError(error.localizedDescription)))
            }
        }.resume()
    }
    
    func registerUser(_ user: UserRegister, completion: @escaping (Result<UserRegistrationResponse, NetworkError>) -> Void) {
        fetchToken { result in
            switch result {
            case .success(let token):
                self.registerUserwithToken(token: token, user: user, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func registerUserwithToken(token: String, user: UserRegister, completion: @escaping (Result<UserRegistrationResponse, NetworkError>) -> Void) {
        guard let url = URL(string: baseURL) else {
            completion(.failure(.invalidResponse))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue("multipart/form-data", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "Token")
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let formData = createFormData(user: user, boundary: boundary)
        request.httpBody = formData
        
        let session = URLSession.shared
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.serverError(error.localizedDescription)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode), let data = data else {
                completion(.failure(.invalidResponse))
                return
            }
            
            do {
                let response = try JSONDecoder().decode(UserRegistrationResponse.self, from: data)
                completion(.success(response))
            } catch {
                completion(.failure(.decodingError(error.localizedDescription)))
            }
        }.resume()
    }
    
    private func createFormData(user: UserRegister, boundary: String) -> Data {
        var formData = Data()
        let boundaryPrefix = "--\(boundary)\r\n"
        
        formData.append(Data("\(boundaryPrefix)Content-Disposition: form-data; name=\"name\"\r\n\r\n\(user.name)\r\n".utf8))
        formData.append(Data("\(boundaryPrefix)Content-Disposition: form-data; name=\"email\"\r\n\r\n\(user.email)\r\n".utf8))
        formData.append(Data("\(boundaryPrefix)Content-Disposition: form-data; name=\"phone\"\r\n\r\n\(user.phone)\r\n".utf8))
        formData.append(Data("\(boundaryPrefix)Content-Disposition: form-data; name=\"position_id\"\r\n\r\n\(user.positionID)\r\n".utf8))
        
        formData.append(Data("\(boundaryPrefix)Content-Disposition: form-data; name=\"photo\"; filename=\"photo.jpg\"\r\n".utf8))
        formData.append(Data("Content-Type: image/jpeg\r\n\r\n".utf8))
        formData.append(user.photo)
        formData.append(Data("\r\n".utf8))
        
        formData.append(Data("--\(boundary)--\r\n".utf8))
        
        return formData
    }
}
