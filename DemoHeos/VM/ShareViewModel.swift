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
}

@Observable @MainActor
final class ShareViewModel: ShareViewModelProtocol {
    var selectedTab: Tab
    var refreshData: Bool
    
    init(
        selectedTab: Tab = .room,
        refreshData: Bool = true
    ) {
        self.selectedTab = selectedTab
        self.refreshData = refreshData
    }
}
