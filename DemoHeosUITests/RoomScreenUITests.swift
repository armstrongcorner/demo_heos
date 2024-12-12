//
//  RoomScreenUITests.swift
//  DemoHeosUITests
//
//  Created by Armstrong Liu on 12/12/24.
//

import XCTest

@MainActor
final class RoomScreenUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false

        app = XCUIApplication()
        app.launchArguments.append("-isUITesting")
    }

    override func tearDownWithError() throws {
        app = nil
    }
    
    func testRoomScreenLoadingState() {
        app.launchArguments.append("-Room-KeepLoading")
        app.launch()

        // Click room tab after app launch
        let roomsTab = app.tabBars.buttons["Rooms"]
        XCTAssertTrue(roomsTab.exists)
        roomsTab.tap()
        
        // Verify loading progress shown
        let progressView = app.activityIndicators["Loading"]
        XCTAssertTrue(progressView.exists, "ProgressView should be displayed while loading.")
    }
    
    func testRoomScreenErrorState() {
        app.launchArguments.append("-Room-WithError")
        app.launch()

        // Click room tab after app launch
        let roomsTab = app.tabBars.buttons["Rooms"]
        XCTAssertTrue(roomsTab.exists)
        roomsTab.tap()
        
        // Verify error message and 'Retry' button shown
        let errorText = app.staticTexts["Error:\nMock error occurred"]
        XCTAssertTrue(errorText.exists, "Error message should be displayed.")
        let retryButton = app.buttons["Retry"]
        XCTAssertTrue(retryButton.exists, "Retry button should be displayed.")
        
        // Verify click 'Retry' button and progress indicator shown
        retryButton.tap()
        let progressView = app.activityIndicators["Loading"]
        XCTAssertTrue(progressView.exists, "ProgressView should be displayed while loading.")
        
        // Verify error message comes again
        let errMsgExists = errorText.waitForExistence(timeout: 2)
        XCTAssertTrue(errMsgExists)
    }
    
    func testRoomScreenWithData() {
        app.launch()

        // Click room tab after app launch
        let roomsTab = app.tabBars.buttons["Rooms"]
        XCTAssertTrue(roomsTab.exists)
        roomsTab.tap()
        
        // Verify loading progress shown then disappear
        let progressView = app.activityIndicators["Loading"]
        let progressDisappear = progressView.waitForNonExistence(timeout: 2)
        XCTAssertTrue(progressDisappear)
        
        // Verify room list and 4 items shown
        let roomList = app.collectionViews.firstMatch
        XCTAssertTrue(roomList.exists, "Room list should be displayed when data is loaded.")
        let device1 = app.staticTexts["Device 1"]
        XCTAssertTrue(device1.exists, "Device 1 should be displayed.")
        let device2 = app.staticTexts["Device 2"]
        XCTAssertTrue(device2.exists, "Device 2 should be displayed.")
        let device3 = app.staticTexts["Device 3"]
        XCTAssertTrue(device3.exists, "Device 3 should be displayed.")
        let device4 = app.staticTexts["Device 4"]
        XCTAssertTrue(device4.exists, "Device 4 should be displayed.")
        
        // Verify the brief view shown
        let artist = app.staticTexts["Test Artist 1"]
        XCTAssertTrue(artist.exists, "Test Artist 1 should be displayed.")
        let playButton = app.buttons["now_playing_controls_play"]
        XCTAssertTrue(playButton.exists, "Play button in BriefView should be displayed.")
        
        // Verify toggle play/pause button
        playButton.tap()
        XCTAssertFalse(playButton.exists, "Play button in BriefView should disappear.")
        let pauseButton = app.buttons["now_playing_controls_pause"]
        XCTAssertTrue(pauseButton.exists, "Pause button in BriefView should be displayed.")
        pauseButton.tap()
        XCTAssertFalse(pauseButton.exists, "Pause button in BriefView should disappear.")
        XCTAssertTrue(playButton.exists, "Play button in BriefView should be displayed.")
    }
}
