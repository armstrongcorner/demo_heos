//
//  DemoHeosApp.swift
//  DemoHeos
//
//  Created by Armstrong Liu on 27/11/2024.
//

import SwiftUI

@main
struct DemoHeosApp: App {
    @State private var shareVM: ShareViewModelProtocol
    @State private var playVM: PlayViewModelProtocol
    
    init() {
        if ProcessInfo.processInfo.arguments.contains("-isUITesting") {
            self.shareVM = MockShareViewModel(isMock: false)
            self.playVM = PlayViewModel(
                devices: [mockDevice1, mockDevice2, mockDevice3],
                selectedDevice: mockDevice1,
                selectedPlayingItem: mockNowPlayingItem1
            )
        } else {
            self.shareVM = ShareViewModel(selectedTab: .room, refreshData: true)
            self.playVM = PlayViewModel()
        }
    }

    var body: some Scene {
        WindowGroup {
            MainScreen()
                .environment(\.shareViewModel, shareVM)
                .environment(\.playViewModel, playVM)
        }
    }
}
