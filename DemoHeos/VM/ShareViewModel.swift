//
//  ShareViewModel.swift
//  DemoHeos
//
//  Created by Armstrong Liu on 12/8/24.
//

import Foundation
import SwiftUI

private struct ShareViewModelKey: @preconcurrency EnvironmentKey {
    @MainActor
    static let defaultValue: ShareViewModelProtocol = ShareViewModel()
}

extension EnvironmentValues {
    var shareViewModel: ShareViewModelProtocol {
        get { self[ShareViewModelKey.self] }
        set { self[ShareViewModelKey.self] = newValue }
    }
}

@MainActor
protocol ShareViewModelProtocol:AnyObject, Sendable {
    var selectedTab: Tab { get set }
    var refreshData: Bool { get set }
    var isMock: Bool { get set }
    
    func toggleMock(_ newValue: Bool)
}

@Observable @MainActor
final class ShareViewModel: ShareViewModelProtocol {
    var selectedTab: Tab
    var refreshData: Bool
    var isMock: Bool
    
    init(
        selectedTab: Tab = .room,
        refreshData: Bool = true,
        isMock: Bool = UserDefaults.standard.bool(forKey: CacheKey.isMock.rawValue)
    ) {
        self.selectedTab = selectedTab
        self.refreshData = refreshData
        self.isMock = isMock
    }
    
    func toggleMock(_ newValue: Bool) {
        isMock = newValue
        UserDefaults.standard.set(newValue, forKey: CacheKey.isMock.rawValue)
    }
}
