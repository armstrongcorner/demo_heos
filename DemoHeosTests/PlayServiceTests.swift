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
        
        let mockNowPlayingItem1: NowPlayingItem = NowPlayingItem(
            deviceID: 1,
            artworkSmall: "https://example.com/artwork_small_1.jpg",
            artworkLarge: "https://example.com/artwork_large_1.jpg",
            trackName: "Test Track 1",
            artistName: "Test Artist 1"
        )
        let mockNowPlayingItem2: NowPlayingItem = NowPlayingItem(
            deviceID: 2,
            artworkSmall: "https://example.com/artwork_small_2.jpg",
            artworkLarge: "https://example.com/artwork_large_2.jpg",
            trackName: "Test Track 2",
            artistName: "Test Artist 2"
        )
        let mockNowPlayingItem3: NowPlayingItem = NowPlayingItem(
            deviceID: 3,
            artworkSmall: "https://example.com/artwork_small_3.jpg",
            artworkLarge: "https://example.com/artwork_large_3.jpg",
            trackName: "Test Track 3",
            artistName: "Test Artist 3"
        )
        let mockNowPlayingItem4: NowPlayingItem = NowPlayingItem(
            deviceID: 4,
            artworkSmall: "https://example.com/artwork_small_4.jpg",
            artworkLarge: "https://example.com/artwork_large_4.jpg",
            trackName: "Test Track 4",
            artistName: "Test Artist 4"
        )
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
