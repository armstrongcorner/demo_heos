//
//  MockShareViewModel.swift
//  DemoHeosTests
//
//  Created by Armstrong Liu on 12/10/24.
//

import Foundation
@testable import DemoHeos

class MockShareViewModel: ShareViewModelProtocol {
    var selectedTab: Tab = .room
    var refreshData: Bool = true
}
