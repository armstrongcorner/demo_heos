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
        let fileName = "TestDeviceResponse"

        do {
            // when
            let result: DeviceModel = try await sut.loadJSONFromAssets(named: fileName, as: DeviceModel.self)
            
            // then
            XCTAssertEqual(result.devices?.count, 3)
            XCTAssertEqual(result.devices?.first?.id, 1)
            XCTAssertEqual(result.devices?.first?.name, "Sydney")
        } catch {
            XCTFail("加载 JSON 失败：\(error)")
        }
    }

    func testLoadJSONFromAssetsFileNotFound() async {
        let fileName = "NonExistentFile"

        do {
            let _: DeviceResponse = try await sut.loadJSONFromAssets(named: fileName, as: DeviceResponse.self)
            XCTFail("预期抛出 assetNotFound 错误，但未抛出")
        } catch FileServiceError.assetNotFound(let missingFileName) {
            XCTAssertEqual(missingFileName, fileName)
        } catch {
            XCTFail("预期抛出 assetNotFound 错误，但抛出了其他错误：\(error)")
        }
    }

    func testLoadJSONFromAssetsDecodingFailed() async {
        // 假设 Assets 中有名为 "InvalidDeviceResponse" 的 JSON 文件，其内容无法解码为 DeviceResponse
        let fileName = "InvalidDeviceResponse"

        do {
            let _: DeviceResponse = try await sut.loadJSONFromAssets(named: fileName, as: DeviceResponse.self)
            XCTFail("预期抛出 decodingFailed 错误，但未抛出")
        } catch FileServiceError.decodingFailed(let decodingError) {
            XCTAssertNotNil(decodingError)
        } catch {
            XCTFail("预期抛出 decodingFailed 错误，但抛出了其他错误：\(error)")
        }
    }
}
