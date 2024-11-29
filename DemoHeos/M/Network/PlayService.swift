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
    func getPlayInfo() async throws -> PlayResponse? {
        let playInfoResponse = try await ApiClient.shared.get(
            url: Endpoint.playInfo.url,
            responseType: PlayResponse.self
        )
        
        return playInfoResponse
    }
}
