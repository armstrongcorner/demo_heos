//
//  InitialViewModel.swift
//  DemoHeos
//
//  Created by Armstrong Liu on 27/11/2024.
//

import Foundation
import Combine

extension Notification.Name {
    static let isDataSourceChanged = Notification.Name("isDataSourceChanged")
}

@MainActor
protocol InitialViewModelProtocol: Sendable {
    var devices: [Device] { get }
    var playingItems: [NowPlayingItem] { get }
    var errorMessage: String? { get }
    var isLoading: Bool { get }
    var refreshData: Bool { get set }
    
    func fetchInitialData() async
}

@Observable @MainActor
final class InitialViewModel: ObservableObject, InitialViewModelProtocol {
    var devices: [Device]
    var playingItems: [NowPlayingItem]
    var errorMessage: String?
    var isLoading: Bool
    var refreshData: Bool
    
    private var cancellables: Set<AnyCancellable> = []
    
    private let deviceService: DeviceServiceProtocol
    private let playService: PlayServiceProtocol
    private let fileService: FileServiceProtocol
    
    init(
        devices: [Device] = [],
        playingItems: [NowPlayingItem] = [],
        errorMessage: String? = nil,
        isLoading: Bool = false,
        refreshData: Bool = true,
        deviceService: DeviceServiceProtocol = DeviceService(),
        playService: PlayServiceProtocol = PlayService(),
        fileService: FileServiceProtocol = FileService()
    ) {
        self.devices = devices
        self.playingItems = playingItems
        self.errorMessage = errorMessage
        self.isLoading = isLoading
        self.refreshData = refreshData
        self.deviceService = deviceService
        self.playService = playService
        self.fileService = fileService
        
        // Listen to the notification
        NotificationCenter.default.publisher(for: .isDataSourceChanged)
            .compactMap { $0.object as? Bool }
            .sink { [weak self] isDataSourceChanged in
                self?.refreshData = isDataSourceChanged
            }
            .store(in: &cancellables)
    }
    
    func fetchInitialData() async {
        isLoading = true
        errorMessage = nil
        
        let isMock: Bool = UserDefaults.standard.bool(forKey: CacheKey.isMock.rawValue)
        if isMock {
            // Mock on: get data from local json file
            print("Get from json file !!!")
            var fileName = "devices"
            do {
                // Load device.json
                let deviceModel = try await fileService.loadJSONFromAssets(named: fileName, as: DeviceModel?.self)
                self.devices = deviceModel?.devices ?? []
                print("total devices: \(self.devices.count)")
                
                // Load nowplaying.json
                fileName = "nowplaying"
                let playModel = try await fileService.loadJSONFromAssets(named: fileName, as: PlayModel?.self)
                self.playingItems = playModel?.nowPlaying ?? []
                print("total playing items: \(self.playingItems.count)")
            } catch let FileServiceError.assetNotFound(fileName: fileName) {
                appendError("Asset not found: \(fileName)")
            } catch let FileServiceError.decodingFailed(error: error) {
                appendError("Decoding error: \(error)")
            } catch {
                appendError("Data fetch failed: \(error.localizedDescription)")
            }
            
            self.isLoading = false
        } else {
            // Mock off: get data from network
            print("Get from network !!!")
            do {
                // Concurrently the two requests for device info and play info
                async let deviceRequest: () = fetchDevices()
                async let playRequest: () = fetchPlayItems()
                
                // Wait for both complete
                let _ = try await (deviceRequest, playRequest)
            } catch {
                appendError("Data fetch failed: \(error.localizedDescription)")
            }
            
            self.isLoading = false
        }
    }
    
    private func fetchDevices() async throws {
        do {
            if let response = try await deviceService.getDeviceInfo() {
                self.devices = response.devices ?? []
                print("total devices: \(self.devices.count)")
            } else {
                throw URLError(.badServerResponse)
            }
        } catch {
            appendError("Device info request failed: \(error.localizedDescription)")
            throw error
        }
    }
        
    private func fetchPlayItems() async throws {
        do {
            if let response = try await playService.getPlayInfo() {
                self.playingItems = response.nowPlaying ?? []
                print("total playing items: \(self.playingItems.count)")
            } else {
                throw URLError(.badServerResponse)
            }
        } catch {
            appendError("Play info request failed: \(error.localizedDescription)")
            throw error
        }
    }
    
    // Combine the err msg
    private func appendError(_ message: String) {
        if let existingError = self.errorMessage {
            errorMessage = "\(existingError)\n\(message)"
        } else {
            errorMessage = message
        }
    }
}
