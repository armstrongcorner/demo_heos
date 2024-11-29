//
//  PlayViewModel.swift
//  DemoHeos
//
//  Created by Armstrong Liu on 28/11/2024.
//

import Foundation

enum PlayState {
    case paused
    case playing
    case stopped
}

@MainActor
protocol PlayViewModelProtocol:AnyObject, Sendable {
    var showBrief: Bool { get set }
    
    func initializePlayStates(with devices: [Device])
    func getPlayState(for deviceID: Int) -> PlayState
    func updatePlayState(for deviceID: Int, to state: PlayState)
}

@Observable @MainActor
final class PlayViewModel: PlayViewModelProtocol {
    private var playStates: [Int: PlayState]
    private var devices: [Device]
    private var nowPlayingItems: [NowPlayingItem]
    
    var showBrief: Bool

    init(
        playStates: [Int: PlayState] = [:],
        devices: [Device] = [],
        nowPlayingItems: [NowPlayingItem] = [],
        showBrief: Bool = false
    ) {
        self.playStates = playStates
        self.devices = devices
        self.nowPlayingItems = nowPlayingItems
        self.showBrief = showBrief
    }

    // Initialize the play state for each device
    func initializePlayStates(with devices: [Device]) {
        devices.forEach { device in
            if let id = device.id {
                playStates[id] = .stopped
            }
        }
    }

    // Get play state for a device
    func getPlayState(for deviceID: Int) -> PlayState {
        return playStates[deviceID] ?? .stopped
    }

    // Update play state for a device
    func updatePlayState(for deviceID: Int, to state: PlayState) {
        playStates[deviceID] = state
    }
}
