//
//  MockFileService.swift
//  DemoHeosTests
//
//  Created by Armstrong Liu on 12/10/24.
//

import Foundation
@testable import DemoHeos

actor MockFileService: FileServiceProtocol {
    var shouldReturnError = false
    var mockFileData: Data?

    func updateFileData(newFileData: Data?) {
        mockFileData = newFileData
    }
    
    func updateShouldReturnError(newValue: Bool) {
        shouldReturnError = newValue
    }
    
    func loadJSONFromAssets<T>(named fileName: String, as type: T.Type) async throws -> T where T: Decodable & Sendable {
        if shouldReturnError {
            throw FileServiceError.assetNotFound(fileName: fileName)
        }
        guard let data = mockFileData else {
            throw FileServiceError.assetNotFound(fileName: fileName)
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
}
