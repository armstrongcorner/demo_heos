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
    var testDefaults: UserDefaults!

    override func setUp() {
        super.setUp()
        
        testDefaults = UserDefaults(suiteName: "au.com.mydemo.ut")
        testDefaults.removePersistentDomain(forName: "au.com.mydemo.ut")
        sut = ShareViewModel(userDefaults: testDefaults)
    }

    override func tearDown() {
        testDefaults.removePersistentDomain(forName: "au.com.mydemo.ut")
        testDefaults = nil
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
    
    func testInitialMock() {
        XCTAssertFalse(sut.isMock)
    }
    
    func testToggleMockAndPersistence() {
        // Verify toggle to true
        // when
        sut.toggleMock(true)
        
        // then
        XCTAssertTrue(sut.isMock)
        var persistedValue = testDefaults.bool(forKey: CacheKey.isMock.rawValue)
        XCTAssertTrue(persistedValue)
        
        // Verify toggle to false
        // when
        sut.toggleMock(false)
        
        // then
        XCTAssertFalse(sut.isMock)
        persistedValue = testDefaults.bool(forKey: CacheKey.isMock.rawValue)
        XCTAssertFalse(persistedValue)
    }
}
