//
//  SettingScreen.swift
//  DemoHeos
//
//  Created by Armstrong Liu on 28/11/2024.
//

import SwiftUI

struct SettingScreen: View {
    @Environment(\.shareViewModel) var shareVM: ShareViewModelProtocol
    @Environment(\.playViewModel) var playVM: PlayViewModelProtocol
    
    var body: some View {
        NavigationView {
            List {
                Toggle("Mock Data", isOn: Binding(
                    get: { shareVM.isMock },
                    set: { newValue in
                        shareVM.toggleMock(newValue)
                        shareVM.refreshData = true
                        playVM.selectedDevice = nil
                        playVM.selectedPlayingItem = nil
                    }
                ))
            }
            .listStyle(.automatic)
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.automatic)
        }
        .tint(.black)
        .accessibilityIdentifier("SettingScreen")
    }
}

#Preview {
    let mockShareVM = MockShareViewModel()
    
    SettingScreen()
        .environment(\.shareViewModel, mockShareVM)
}
