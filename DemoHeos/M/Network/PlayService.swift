//
//  PlayService.swift
//  DemoHeos
//
//  Created by Armstrong Liu on 27/11/2024.
//

import Foundation

protocol PlayServiceProtocol: Sendable {
    func getPlayInfo() async throws -> PlayResponse?
}

actor PlayService: PlayServiceProtocol {
    private let apiClient: ApiClientProtocol
    
    init(apiClient: ApiClientProtocol = ApiClient.shared) {
        self.apiClient = apiClient
    }
    
    func getPlayInfo() async throws -> PlayResponse? {
        let playInfoResponse = try await apiClient.get(
            url: Endpoint.playInfo.url,
            headers: [:],
            body: nil,
            responseType: PlayResponse.self
        )
        
        return playInfoResponse
    }
}
