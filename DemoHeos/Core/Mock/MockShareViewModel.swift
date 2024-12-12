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
    var isMock: Bool
    
    init(isMock: Bool = false) {
        self.isMock = isMock
    }
    
    func toggleMock(_ newValue: Bool) {
        // Isolate UserDefaults for mock
        isMock = newValue
        let mockDefaults = UserDefaults(suiteName: "au.com.mydemo.mocks")
        mockDefaults?.set(newValue, forKey: CacheKey.isMock.rawValue)
    }
}
