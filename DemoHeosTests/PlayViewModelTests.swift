//
//  PlayViewModelTests.swift
//  DemoHeosTests
//
//  Created by Armstrong Liu on 12/10/24.
//

import XCTest
@testable import DemoHeos

@MainActor
final class PlayViewModelTests: XCTestCase {
    var sut: PlayViewModel!
    var devices: [Device]!

    override func setUp() {
        super.setUp()
        
        let mockDevice1: Device = Device(id: 1, name: "Device 1")
        let mockDevice2: Device = Device(id: 2, name: "Device 2")
        devices = [mockDevice1, mockDevice2]
        
        sut = PlayViewModel()
    }

    override func tearDown() {
        sut = nil
        devices = nil
        
        super.tearDown()
    }

    func testInitializePlayStates() {
        // when
        sut.initializePlayStates(with: devices)
        
        // then
        XCTAssertEqual(sut.getPlayState(for: 1), .stopped)
        XCTAssertEqual(sut.getPlayState(for: 2), .stopped)
    }

    func testUpdateCurrentPlayState() {
        // given
        let currentDevice = devices[0]
        sut.selectedDevice = currentDevice
        
        // when
        sut.updateCurrentPlayState(newState: .playing)
        
        // then
        XCTAssertEqual(sut.getCurrentPlayState(), .playing)
    }

    func testGetPlayStateForDevice() {
        // given
        let currentDevice = devices[0]
        sut.selectedDevice = currentDevice
        
        // when
        sut.initializePlayStates(with: devices)
        sut.updateCurrentPlayState(newState: .playing)
        
        // then
        XCTAssertEqual(sut.getPlayState(for: 1), .playing)
        XCTAssertEqual(sut.getPlayState(for: 2), .stopped)
    }
}
