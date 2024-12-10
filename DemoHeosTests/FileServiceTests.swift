//
//  FileServiceTests.swift
//  DemoHeosTests
//
//  Created by Armstrong Liu on 12/10/24.
//

import XCTest
@testable import DemoHeos

final class FileServiceTests: XCTestCase {
    var sut: FileService!

    override func setUp() {
        super.setUp()
        
        sut = FileService()
    }

    override func tearDown() {
        sut = nil
        
        super.tearDown()
    }

    func testLoadJSONFromAssetsSuccess() async throws {
        // given
        let fileName = "test_devices"

        do {
            // when
            let result: DeviceModel = try await sut.loadJSONFromAssets(named: fileName, as: DeviceModel.self)
            
            // then
            XCTAssertEqual(result.devices?.count, 3)
            XCTAssertEqual(result.devices?.first?.id, 1)
            XCTAssertEqual(result.devices?.first?.name, "Sydney")
        } catch {
            XCTFail("Load json file error: \(error)")
        }
    }

    func testLoadJSONFromAssetsFileNotFound() async {
        // given
        let fileName = "no_such_file"

        do {
            // when
            let _ = try await sut.loadJSONFromAssets(named: fileName, as: DeviceModel.self)
            XCTFail("Fail: No expected error thrown, should throw out 'assetNotFound' error")
        } catch FileServiceError.assetNotFound(let missingFileName) {
            // then
            XCTAssertEqual(missingFileName, fileName)
        } catch {
            // fail
            XCTFail("Fail: Should throw out 'assetNotFound' error, but throw out other error: \(error)")
        }
    }

    func testLoadJSONFromAssetsDecodingFailed() async {
        // given
        let fileName = "invalid_test_devices"

        do {
            // when
            let _ = try await sut.loadJSONFromAssets(named: fileName, as: DeviceModel.self)
            XCTFail("Fail: No expected error thrown, should throw out 'decodingFailed' error")
        } catch FileServiceError.decodingFailed(let decodingError) {
            // then
            XCTAssertNotNil(decodingError)
        } catch {
            // fail
            XCTFail("Fail: Should throw out 'decodingFailed' error, but throw out other error: \(error)")
        }
    }
}
