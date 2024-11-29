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
    func getDeviceInfo() async throws -> DeviceResponse? {
        let deviceInfoResponse = try await ApiClient.shared.get(
            url: Endpoint.deviceInfo.url,
            responseType: DeviceResponse.self
        )
        
        return deviceInfoResponse
    }
}
