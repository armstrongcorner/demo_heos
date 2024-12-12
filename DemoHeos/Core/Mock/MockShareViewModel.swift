//
//  MockShareViewModel.swift
//  DemoHeosTests
//
//  Created by Armstrong Liu on 12/10/24.
//

import Foundation

class MockShareViewModel: ShareViewModelProtocol {
    var selectedTab: Tab = .room
    var refreshData: Bool = true
    var isMock: Bool = false
    
    func toggleMock(_ newValue: Bool) {
        // Isolate UserDefaults for mock
        let mockDefaults = UserDefaults(suiteName: "au.com.mydemo.mocks")
        mockDefaults?.set(newValue, forKey: CacheKey.isMock.rawValue)
    }
}
