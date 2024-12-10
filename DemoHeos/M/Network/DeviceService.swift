//
//  DeviceService.swift
//  DemoHeos
//
//  Created by Armstrong Liu on 27/11/2024.
//

import Foundation

protocol DeviceServiceProtocol: Sendable {
    func getDeviceInfo() async throws -> DeviceResponse?
}

actor DeviceService: DeviceServiceProtocol {
    private let apiClient: ApiClientProtocol
    
    init(apiClient: ApiClientProtocol = ApiClient.shared) {
        self.apiClient = apiClient
    }
    
    func getDeviceInfo() async throws -> DeviceResponse? {
        let deviceInfoResponse = try await apiClient.get(
            url: Endpoint.deviceInfo.url,
            headers: [:],
            body: nil,
            responseType: DeviceResponse.self
        )
        
        return deviceInfoResponse
    }
}
