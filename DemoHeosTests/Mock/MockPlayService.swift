//
//  MockPlayService.swift
//  DemoHeosTests
//
//  Created by Armstrong Liu on 12/10/24.
//

import Foundation
@testable import DemoHeos

actor MockPlayService: PlayServiceProtocol {
    var shouldReturnError = false
    var mockPlayResponse: PlayResponse?

    func updatePlayResponse(newResponse: PlayResponse?) {
        mockPlayResponse = newResponse
    }
    
    func updateShouldReturnError(newValue: Bool) {
        shouldReturnError = newValue
    }

    func getPlayInfo() async throws -> PlayResponse? {
        if shouldReturnError {
            throw URLError(.badServerResponse)
        }
        return mockPlayResponse
    }
}
