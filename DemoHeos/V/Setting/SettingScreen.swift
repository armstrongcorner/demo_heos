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
    
    @State private var isMock: Bool
    
    init(isMock: Bool = UserDefaults.standard.bool(forKey: CacheKey.isMock.rawValue)) {
        self.isMock = isMock
    }
    
    var body: some View {
        NavigationView {
            List {
                Toggle("Mock Data", isOn: $isMock)
                    .onChange(of: isMock) { _, newValue in
                        // Use local json data or not
                        UserDefaults.standard.set(newValue, forKey: CacheKey.isMock.rawValue)
                        // Reset fetch data and play state
                        shareVM.refreshData = true
                        playVM.selectedDevice = nil
                        playVM.selectedPlayingItem = nil
                    }
            }
            .listStyle(.automatic)
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.automatic)
        }
    }
}

#Preview {
//    SettingScreen(isMock: true)
    SettingScreen(isMock: false)
}
