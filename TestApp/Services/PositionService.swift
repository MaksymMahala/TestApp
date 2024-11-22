//
//  PositionService.swift
//  TestApp
//
//  Created by Max on 22.11.2024.
//

import Foundation

class PositionService: PositionServiceProtocol {
    private let baseURL = "https://frontend-test-assignment-api.abz.agency/api/v1/positions"
    
    func fetchPositions(completion: @escaping (Result<[Positions], Error>) -> Void) {
        guard let url = URL(string: baseURL) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(NSError(domain: "Invalid response", code: 400, userInfo: nil)))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 400, userInfo: nil)))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(PositionResponse.self, from: data)
                if decodedResponse.success, let positions = decodedResponse.positions {
                    completion(.success(positions))
                } else {
                    let message = decodedResponse.message ?? "Unknown error"
                    completion(.failure(NSError(domain: message, code: 422, userInfo: nil)))
                }
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
