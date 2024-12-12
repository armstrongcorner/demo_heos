//
//  MainScreenUITests.swift
//  DemoHeosUITests
//
//  Created by Armstrong Liu on 12/12/24.
//

import XCTest

final class MainScreenUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func testTabSwitch() throws {
        // Check 3 tabs exist
        let nowPlayingTab = app.tabBars.buttons["Play"]
        XCTAssertTrue(nowPlayingTab.exists, "The 'Now Playing' tab should exist.")
        let roomsTab = app.tabBars.buttons["Rooms"]
        XCTAssertTrue(roomsTab.exists, "The 'Rooms' tab should exist.")
        let settingsTab = app.tabBars.buttons["Settings"]
        XCTAssertTrue(settingsTab.exists, "The 'Settings' tab should exist.")
        
        // Switch to SettingScreen
        settingsTab.tap()
        let settingsScreen = app.otherElements["SettingScreen"]
        XCTAssertTrue(settingsScreen.exists, "Settings screen should be displayed.")
        
        // Switch to RoomScreen
        roomsTab.tap()
        let roomScreen = app.otherElements["RoomScreen"]
        XCTAssertTrue(roomScreen.exists, "Room screen should be displayed.")
        
        // Switch to NowPlayingScreen
        nowPlayingTab.tap()
        let nowPlayingScreen = app.otherElements["NowPlayingScreen"]
        XCTAssertTrue(nowPlayingScreen.exists, "Now Playing screen should be displayed.")
    }

    func testTabDefaultSelection() throws {
        // Default 'Rooms' tab selected
        let selectedTab = app.tabBars.buttons["Rooms"]
        XCTAssertTrue(selectedTab.isSelected, "The default selected tab should be 'Rooms'.")
    }
}
