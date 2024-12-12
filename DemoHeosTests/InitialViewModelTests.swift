//
//  InitialViewModelTests.swift
//  DemoHeosTests
//
//  Created by Armstrong Liu on 12/10/24.
//

import XCTest
@testable import DemoHeos

@MainActor
final class InitialViewModelTests: XCTestCase {
    var sut: InitialViewModel!
    
    var mockDeviceService: MockDeviceService!
    var mockPlayService: MockPlayService!
    var mockFileService: MockFileService!

    override func setUp() {
        super.setUp()
        
        mockDeviceService = MockDeviceService()
        mockPlayService = MockPlayService()
        mockFileService = MockFileService()
        
        // Inject the mock services
        sut = InitialViewModel(
            deviceService: mockDeviceService,
            playService: mockPlayService,
            fileService: mockFileService
        )
    }

    override func tearDown() {
        sut = nil
        mockDeviceService = nil
        mockPlayService = nil
        mockFileService = nil
        
        super.tearDown()
    }

    func testFetchDataFromNetworkSuccess() async {
        // given
        await mockDeviceService.updateDeviceResponse(newResponse: DeviceResponse(devices: [mockDevice1, mockDevice2, mockDevice3, mockDevice4]))
        await mockPlayService.updatePlayResponse(newResponse: PlayResponse(nowPlaying: [mockNowPlayingItem1, mockNowPlayingItem2, mockNowPlayingItem3, mockNowPlayingItem4]))
        
        // when
        let expectation = self.expectation(description: "Fetch remote data done")
        await sut.fetchInitialData(isMock: false)
        
        // then
        XCTAssertEqual(sut.fetchDataState, .done)
        XCTAssertEqual(sut.devices.count, 4)
        XCTAssertEqual(sut.playingItems.count, 4)
        expectation.fulfill()
        await fulfillment(of: [expectation])
    }
    
    func testFetchDataFromNetworkError() async {
        // given
        await mockDeviceService.updateShouldReturnError(newValue: true)
        
        // when
        let expectation = self.expectation(description: "Fetch remote data fails with error")
        await sut.fetchInitialData(isMock: false)
        
        // then
        XCTAssertEqual(sut.fetchDataState, .error)
        XCTAssertNotNil(sut.errorMessage)
        expectation.fulfill()
        await fulfillment(of: [expectation])
    }

    func testFetchDataFromFileSuccess() async {
        // given
        let deviceData = mockDevicesRawString.data(using: .utf8)
        
        // when
        await mockFileService.updateFileData(newFileData: deviceData)
        let expectation1 = self.expectation(description: "Fetch device data from file done")
        await sut.fetchInitialData(isMock: true)
        
        // then
        XCTAssertEqual(sut.fetchDataState, .done)
        XCTAssertEqual(sut.devices.count, 3)
        expectation1.fulfill()
        
        // given
        let playData = mockNowPlayingRawString.data(using: .utf8)
        
        // when
        await mockFileService.updateFileData(newFileData: playData)
        let expectation2 = self.expectation(description: "Fetch play info data from file done")
        await sut.fetchInitialData(isMock: true)
        
        // then
        XCTAssertEqual(sut.fetchDataState, .done)
        XCTAssertEqual(sut.playingItems.count, 3)
        expectation2.fulfill()
        
        await fulfillment(of: [expectation1, expectation2])
    }
    
    func testFetchDataFromFileError() async {
        // given
        await mockFileService.updateShouldReturnError(newValue: true)
        
        // when
        let expectation = self.expectation(description: "Fetch local data fails with error")
        await sut.fetchInitialData(isMock: true)
        
        // then
        XCTAssertEqual(sut.fetchDataState, .error)
        XCTAssertNotNil(sut.errorMessage)
        expectation.fulfill()
        await fulfillment(of: [expectation])
    }
}
