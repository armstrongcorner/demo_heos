//
//  SettingScreenUITests.swift
//  DemoHeosUITests
//
//  Created by Armstrong Liu on 12/12/24.
//

import XCTest

final class SettingScreenUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false

        app = XCUIApplication()
        app.launchArguments.append("-isUITesting")
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func testToggleMockData() throws {
        // Click settings tab after app launch
        let settingsTab = app.tabBars.buttons["Settings"]
        XCTAssertTrue(settingsTab.exists, "The 'Settings' tab should exist.")
        settingsTab.tap()

        // Verify 'Mock Data' initial state
        let mockDataToggle = app.switches["Mock Data"]
        XCTAssertTrue(mockDataToggle.exists, "The 'Mock Data' toggle should exist.")
        XCTAssertEqual(mockDataToggle.value as? String, "0", "Mock Data should be OFF initially.")

        // Verify toggle
        mockDataToggle.switches.firstMatch.tap()
        XCTAssertEqual(mockDataToggle.switches.firstMatch.value as? String, "1", "Mock Data should be ON after toggling.")
    }
}
