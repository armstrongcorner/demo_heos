//
//  MockApiClient.swift
//  DemoHeos
//
//  Created by Armstrong Liu on 12/10/24.
//

import Foundation
@testable import DemoHeos

final class MockApiClient: ApiClientProtocol {
    var mockResponse: Decodable?
    var shouldThrowError = false

    func get<T: Decodable>(url: URL, headers: [String: String], body: Data?, responseType: T.Type) async throws -> T {
        if shouldThrowError {
            throw URLError(.badServerResponse)
        }
        guard let response = mockResponse as? T else {
            throw URLError(.cannotDecodeContentData)
        }
        return response
    }

    func post<T: Decodable>(url: URL, headers: [String: String], body: Data?, responseType: T.Type) async throws -> T {
        fatalError("Not implemented")
    }

    func put<T: Decodable>(url: URL, headers: [String: String], body: Data?, responseType: T.Type) async throws -> T {
        fatalError("Not implemented")
    }

    func delete<T: Decodable>(url: URL, headers: [String: String], body: Data?, responseType: T.Type) async throws -> T {
        fatalError("Not implemented")
    }
}
