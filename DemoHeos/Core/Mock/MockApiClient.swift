//
//  MockApiClient.swift
//  DemoHeos
//
//  Created by Armstrong Liu on 12/10/24.
//

import Foundation

actor MockApiClient: ApiClientProtocol {
    var mockResponse: Decodable?
    var shouldThrowError: Bool = false
    
    func setMockResponse(_ response: Decodable?) {
        mockResponse = response
    }
    
    func setShouldThrowError(_ newValue: Bool) {
        shouldThrowError = newValue
    }

    func get<T: Decodable & Sendable>(url: URL, headers: [String: String], body: Data?, responseType: T.Type) async throws -> T {
        if shouldThrowError {
            throw URLError(.badServerResponse)
        }
        guard let response = mockResponse as? T else {
            throw URLError(.cannotDecodeContentData)
        }
        return response
    }

    func post<T: Decodable & Sendable>(url: URL, headers: [String: String], body: Data?, responseType: T.Type) async throws -> T {
        fatalError("Not implemented")
    }

    func put<T: Decodable & Sendable>(url: URL, headers: [String: String], body: Data?, responseType: T.Type) async throws -> T {
        fatalError("Not implemented")
    }

    func delete<T: Decodable & Sendable>(url: URL, headers: [String: String], body: Data?, responseType: T.Type) async throws -> T {
        fatalError("Not implemented")
    }
}
