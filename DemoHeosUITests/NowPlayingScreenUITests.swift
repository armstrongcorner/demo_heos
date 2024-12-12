//
//  NowPlayingScreenUITests.swift
//  DemoHeosUITests
//
//  Created by Armstrong Liu on 12/12/24.
//

import XCTest

final class NowPlayingScreenUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false

        app = XCUIApplication()
//        app.launchArguments.append("-isUITesting")
//        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func testNowPlayingScreenWithCurrentPlayState() throws {
        app.launchArguments.append("-isUITesting")
        app.launch()

        // Click play tab after app launch
        let playTab = app.tabBars.buttons["Play"]
        XCTAssertTrue(playTab.exists)
        playTab.tap()

        // Verify mock play info shown
        let trackNameText = app.staticTexts["Test Track 1"]
        XCTAssertTrue(trackNameText.exists, "Track name should be displayed.")
        let artistNameText = app.staticTexts["Test Artist 1"]
        XCTAssertTrue(artistNameText.exists, "Artist name should be displayed.")

        // Verify play/pause button exist
        let playPauseButton = app.buttons["PlayPauseButton"]
        XCTAssertTrue(playPauseButton.exists, "Play/Pause button should exist.")

        // Verify play/pause button initial state
        XCTAssertEqual(playPauseButton.label, "Play", "The button should initially display 'play' image.")
        
        // Verify toggle the play/pause button
        playPauseButton.tap()
        XCTAssertEqual(playPauseButton.label, "Pause", "The button should be changed to 'pause' image.")
        playPauseButton.tap()
        XCTAssertEqual(playPauseButton.label, "Play", "The button should be changed back to 'play' image.")
    }

    func testNowPlayingScreenWithoutCurrentPlayState() throws {
        app.launch()
        
        // Click play tab after app launch
        let playTab = app.tabBars.buttons["Play"]
        XCTAssertTrue(playTab.exists)
        playTab.tap()

        // Verify 'No room selected' state
        let noRoomText = app.staticTexts["No room selected yet"]
        XCTAssertTrue(noRoomText.exists, "Should display 'No room selected yet' when there is no current play state.")
    }
}
