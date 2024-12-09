//
//  PlayViewModel.swift
//  DemoHeos
//
//  Created by Armstrong Liu on 28/11/2024.
//

import Foundation
import SwiftUI

//private struct PlayViewModelKey: EnvironmentKey {
//    static var defaultValue: PlayViewModelProtocol {
//        get {
//            Task { @MainActor in
//                return PlayViewModel()
//            }
//            fatalError("Asynchronously only")
//        }
//    }
//}
private struct PlayViewModelKey: EnvironmentKey {
    static let defaultValue: PlayViewModelProtocol = makeDefaultViewModel()
}

@MainActor
private func makeDefaultViewModel() -> PlayViewModelProtocol {
    PlayViewModel()
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
    private var playStates: [Int: PlayState]
    private var devices: [Device]

    var selectedDevice: Device?
    var selectedPlayingItem: NowPlayingItem?
    var showBrief: Bool
//    
//    var selectedPlayState: PlayState? {
//        if let selectedDevice = selectedDevice {
//            
//        }
//        return nil
//    }

    init(
        playStates: [Int: PlayState] = [:],
        devices: [Device] = [],
        selectedDevice: Device? = nil,
        selectedPlayingItem: NowPlayingItem? = nil,
        showBrief: Bool = false
    ) {
        self.playStates = playStates
        self.devices = devices
        self.selectedDevice = selectedDevice
        self.selectedPlayingItem = selectedPlayingItem
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
