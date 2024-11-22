//
//  NetworkMonitorManager.swift
//  TestApp
//
//  Created by Max on 21.11.2024.
//

import Network
import Combine

class NetworkMonitorManager: ObservableObject {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    @Published var isConnected: Bool = true
    @Published var navigateToUsersView = false

    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = (path.status == .satisfied)
            }
        }
        monitor.start(queue: queue)
    }
}
