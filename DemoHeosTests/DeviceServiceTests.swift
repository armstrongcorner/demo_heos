//
//  DeviceServiceTests.swift
//  DemoHeosTests
//
//  Created by Armstrong Liu on 12/10/24.
//

import XCTest
@testable import DemoHeos

final class DeviceServiceTests: XCTestCase {
    var sut: DeviceService!
    var mockApiClient: MockApiClient!
    var mockResponse: DeviceResponse!

    override func setUp() {
        super.setUp()
        
        mockApiClient = MockApiClient()
        sut = DeviceService(apiClient: mockApiClient)
        
        let mockDevice1: Device = Device(id: 1, name: "Device 1")
        let mockDevice2: Device = Device(id: 2, name: "Device 2")
        let mockDevice3: Device = Device(id: 3, name: "Device 3")
        let mockDevice4: Device = Device(id: 4, name: "Device 4")
        mockResponse = DeviceResponse(devices: [mockDevice1, mockDevice2, mockDevice3, mockDevice4])
    }

    override func tearDown() {
        sut = nil
        mockApiClient = nil
        mockResponse = nil
        
        super.tearDown()
    }

    func testGetDeviceInfoSuccess() async throws {
        // given
        mockApiClient.mockResponse = mockResponse

        // when
        let result = try await sut.getDeviceInfo()

        // then
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.devices?.count, 4)
        XCTAssertEqual(result?.devices?.first?.id, 1)
        XCTAssertEqual(result?.devices?.first?.name, "Device 1")
    }

    func testGetDeviceInfoFailure() async throws {
        // given
        mockApiClient.shouldThrowError = true

        do {
            // when
            _ = try await sut.getDeviceInfo()
            XCTFail("Fail: No expected error thrown, should throw out badServerResponse error")
        } catch {
            // then
            XCTAssertEqual((error as NSError).code, URLError.badServerResponse.rawValue)
        }
    }
}

