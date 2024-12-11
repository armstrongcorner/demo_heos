//
//  PlayServiceTests.swift
//  DemoHeosTests
//
//  Created by Armstrong Liu on 12/10/24.
//

import XCTest
@testable import DemoHeos

final class PlayServiceTests: XCTestCase {
    var sut: PlayService!
    var mockApiClient: MockApiClient!
    var mockResponse: PlayResponse!
    
    override func setUp() {
        super.setUp()
        
        mockApiClient = MockApiClient()
        sut = PlayService(apiClient: mockApiClient)
        
        mockResponse = PlayResponse(nowPlaying: [mockNowPlayingItem1, mockNowPlayingItem2, mockNowPlayingItem3, mockNowPlayingItem4])
    }
    
    override func tearDown() {
        sut = nil
        mockApiClient = nil
        mockResponse = nil
        
        super.tearDown()
    }
    
    func testGetPlayInfoSuccess() async throws {
        // given
        mockApiClient.mockResponse = mockResponse
        
        // when
        let result = try await sut.getPlayInfo()
        
        // then
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.nowPlaying?.count, 4)
        XCTAssertEqual(result?.nowPlaying?.first?.deviceID, 1)
        XCTAssertEqual(result?.nowPlaying?.first?.trackName, "Test Track 1")
        XCTAssertEqual(result?.nowPlaying?.first?.artistName, "Test Artist 1")
    }
    
    func testGetPlayInfoFailure() async throws {
        // given
        mockApiClient.shouldThrowError = true
        
        do {
            // when
            _ = try await sut.getPlayInfo()
            XCTFail("Fail: No expected error thrown, should throw out badServerResponse error")
        } catch {
            // then
            XCTAssertEqual((error as NSError).code, URLError.badServerResponse.rawValue)
        }
    }
}
