//
//  MockInitialViewModel.swift
//  DemoHeosTests
//
//  Created by Armstrong Liu on 12/11/24.
//

import Foundation

@Observable @MainActor
class MockInitialViewModel: InitialViewModelProtocol {
    var devices: [Device] = []
    var playingItems: [NowPlayingItem] = []
    var errorMessage: String?
    var fetchDataState: FetchDataState = .idle

    private var shouldKeepLoading: Bool
    private var shouldReturnError: Bool
    private var shouldUseMockData: Bool

    init(
        shouldKeepLoading: Bool = false,
        shouldReturnError: Bool = false,
        shouldUseMockData: Bool = false
    ) {
        self.shouldKeepLoading = shouldKeepLoading
        self.shouldReturnError = shouldReturnError
        self.shouldUseMockData = shouldUseMockData
    }

    func fetchInitialData(isMock: Bool) async {
        // Mock start loading
        fetchDataState = .loading
        errorMessage = nil
        
        try? await Task.sleep(nanoseconds: 1 * 1_000_000_000)
        
        if !shouldKeepLoading {
            if shouldReturnError {
                // Mock error
                fetchDataState = .error
                errorMessage = "Mock error occurred"
            } else {
                if shouldUseMockData {
                    // Mock load from local file
                    devices = [mockDevice1, mockDevice2, mockDevice3]
                    playingItems = [mockNowPlayingItem1, mockNowPlayingItem2, mockNowPlayingItem3]
                    fetchDataState = .done
                } else {
                    // Mock load from network
                    devices = [mockDevice1, mockDevice2, mockDevice3, mockDevice4]
                    playingItems = [mockNowPlayingItem1, mockNowPlayingItem2, mockNowPlayingItem3, mockNowPlayingItem4]
                    fetchDataState = .done
                }
            }
        }
    }
}
