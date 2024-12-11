//
//  PlayViewModel.swift
//  DemoHeos
//
//  Created by Armstrong Liu on 28/11/2024.
//

import Foundation
import SwiftUI

private struct PlayViewModelKey: @preconcurrency EnvironmentKey {
    @MainActor
    static let defaultValue: PlayViewModelProtocol = PlayViewModel()
}

extension EnvironmentValues {
    var playViewModel: PlayViewModelProtocol {
        get { self[PlayViewModelKey.self] }
        set { self[PlayViewModelKey.self] = newValue }
    }
}

enum PlayState {
    case paused
    case playing
    case stopped
}

@MainActor
protocol PlayViewModelProtocol: AnyObject, Sendable {
    var showBrief: Bool { get set }
    var selectedDevice: Device? { get set }
    var selectedPlayingItem: NowPlayingItem? { get set }
    
    func initializePlayStates(with devices: [Device])
    func getCurrentPlayState() -> PlayState?
    func updateCurrentPlayState(newState: PlayState)
    func getPlayState(for deviceID: Int) -> PlayState
}

@Observable @MainActor
final class PlayViewModel: PlayViewModelProtocol {
    private var playStates: [Int: PlayState] = [:]

    var selectedDevice: Device?
    var selectedPlayingItem: NowPlayingItem?
    var showBrief: Bool

    init(
        devices: [Device] = [],
        selectedDevice: Device? = nil,
        selectedPlayingItem: NowPlayingItem? = nil,
        showBrief: Bool = false
    ) {
        self.selectedDevice = selectedDevice
        self.selectedPlayingItem = selectedPlayingItem
        self.showBrief = showBrief
        
        initializePlayStates(with: devices)
    }

    // Initialize the play state for each device
    func initializePlayStates(with devices: [Device]) {
        devices.forEach { device in
            if let id = device.id {
                playStates[id] = .stopped
            }
        }
    }
    
    func getCurrentPlayState() -> PlayState? {
        if let selectedDevice = self.selectedDevice {
            return getPlayState(for: selectedDevice.id ?? 0)
        }
        
        return nil
    }

    func updateCurrentPlayState(newState: PlayState) {
        if let selectedDevice = self.selectedDevice {
            playStates[selectedDevice.id ?? 0] = newState
        }
    }
    
    // Get play state for a device
    func getPlayState(for deviceID: Int) -> PlayState {
        return playStates[deviceID] ?? .stopped
    }
}
