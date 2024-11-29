//
//  SettingScreen.swift
//  DemoHeos
//
//  Created by Armstrong Liu on 28/11/2024.
//

import SwiftUI

struct SettingScreen: View {
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
                        // Refresh the data if change
                        UserDefaults.standard.set(true, forKey: CacheKey.needRefresh.rawValue)
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
    SettingScreen()
}
