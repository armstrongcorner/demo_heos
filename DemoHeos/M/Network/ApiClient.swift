//
//  ApiClient.swift
//  DemoHeos
//
//  Created by Armstrong Liu on 27/11/2024.
//

import Foundation

protocol ApiClientProtocol: Sendable {
    func get<T: Decodable>(url: URL, headers: [String: String], body: Data?, responseType: T.Type) async throws -> T
    func post<T: Decodable>(url: URL, headers: [String: String], body: Data?, responseType: T.Type) async throws -> T
    func put<T: Decodable>(url: URL, headers: [String: String], body: Data?, responseType: T.Type) async throws -> T
    func delete<T: Decodable>(url: URL, headers: [String: String], body: Data?, responseType: T.Type) async throws -> T
}

final class ApiClient: ApiClientProtocol {
    static let shared = ApiClient()
    
    private init() {}
    
    // Get default headers
    func getHeaders() async -> [String: String] {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
        
        let headers = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "x-app-os": "iOS",
            "x-app-version": appVersion,
        ]

        /*
         You can also add auth token here like:
         headers["Authorization"] = "Bearer \(token)"
         */
        
        return headers
    }
    
    // Common http request method
    func sendRequest<T: Decodable>(url: URL,
                                   method: String,
                                   headers: [String: String] = [:],
                                   body: Data? = nil,
                                   responseType: T.Type) async throws -> T {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.httpBody = body
        // Set default headers
        await getHeaders().forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        // Set custom headers
        headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decodedResponse = try JSONDecoder().decode(responseType, from: data)
        return decodedResponse
    }
    
    // GET
    func get<T: Decodable>(url: URL,
                           headers: [String: String] = [:],
                           body: Data? = nil,
                           responseType: T.Type) async throws -> T {
        return try await sendRequest(url: url, method: "GET", headers: headers, body: body, responseType: responseType)
    }
    
    // POST
    func post<T: Decodable>(url: URL,
                            headers: [String: String] = [:],
                            body: Data? = nil,
                            responseType: T.Type) async throws -> T {
        return try await sendRequest(url: url, method: "POST", headers: headers, body: body, responseType: responseType)
    }
    
    // PUT
    func put<T: Decodable>(url: URL,
                           headers: [String: String] = [:],
                           body: Data? = nil,
                           responseType: T.Type) async throws -> T {
        return try await sendRequest(url: url, method: "PUT", headers: headers, body: body, responseType: responseType)
    }
    
    // DETETE
    func delete<T: Decodable>(url: URL,
                              headers: [String: String] = [:],
                              body: Data? = nil,
                              responseType: T.Type) async throws -> T {
        return try await sendRequest(url: url, method: "DELETE", headers: headers, body: body, responseType: responseType)
    }
}
