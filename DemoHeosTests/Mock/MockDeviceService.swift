//
//  MockDeviceService.swift
//  DemoHeosTests
//
//  Created by Armstrong Liu on 12/10/24.
//

import Foundation
@testable import DemoHeos

actor MockDeviceService: DeviceServiceProtocol {
    var shouldReturnError = false
    var mockDeviceResponse: DeviceResponse?

    func updateDeviceResponse(newResponse: DeviceResponse?) {
        mockDeviceResponse = newResponse
    }
    
    func updateShouldReturnError(newValue: Bool) {
        shouldReturnError = newValue
    }
    
    func getDeviceInfo() async throws -> DeviceResponse? {
        if shouldReturnError {
            throw URLError(.badServerResponse)
        }
        return mockDeviceResponse
    }
}
