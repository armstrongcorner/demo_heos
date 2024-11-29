//
//  FileService.swift
//  DemoHeos
//
//  Created by Armstrong Liu on 28/11/2024.
//

import Foundation
import UIKit

enum FileServiceError: Error {
    case assetNotFound(fileName: String)
    case decodingFailed(error: Error)
}

protocol FileServiceProtocol: Sendable {
    func loadJSONFromAssets<T: Decodable & Sendable>(named fileName: String, as type: T.Type) async throws -> T
}

actor FileService: FileServiceProtocol {
    func loadJSONFromAssets<T: Decodable & Sendable>(named fileName: String, as type: T.Type) async throws -> T {
        guard let dataAsset = NSDataAsset(name: fileName) else {
            throw FileServiceError.assetNotFound(fileName: fileName)
        }
        
        let decoder = JSONDecoder()
        do {
            let model = try decoder.decode(type, from: dataAsset.data)
            return model
        } catch {
            print("Failed to decode: \(error)")
            throw FileServiceError.decodingFailed(error: error)
        }
    }
}
