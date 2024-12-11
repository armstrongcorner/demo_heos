//
//  ShareViewModelTests.swift
//  DemoHeosTests
//
//  Created by Armstrong Liu on 12/10/24.
//

import XCTest
@testable import DemoHeos

@MainActor
final class ShareViewModelTests: XCTestCase {
    var sut: ShareViewModel!

    override func setUp() {
        super.setUp()
        sut = ShareViewModel()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testInitialValues() {
        XCTAssertEqual(sut.selectedTab, .room)
        XCTAssertTrue(sut.refreshData)
    }

    func testSelectedTabUpdate() {
        sut.selectedTab = .setting
        XCTAssertEqual(sut.selectedTab, .setting)
    }

    func testRefreshDataUpdate() {
        sut.refreshData = false
        XCTAssertFalse(sut.refreshData)
    }
}
