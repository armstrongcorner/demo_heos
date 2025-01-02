//
//  InitialViewModel.swift
//  DemoHeos
//
//  Created by Armstrong Liu on 27/11/2024.
//

import Foundation

enum FetchDataState {
    case done
    case loading
    case error
    case idle
}

@MainActor
protocol InitialViewModelProtocol: Sendable {
    var devices: [Device] { get }
    var playingItems: [NowPlayingItem] { get }
    var errorMessage: String? { get }
    var fetchDataState: FetchDataState { get }
    
    func fetchInitialData(isMock: Bool) async
}

extension InitialViewModelProtocol {
    func fetchInitialData(isMock: Bool = UserDefaults.standard.bool(forKey: CacheKey.isMock.rawValue)) async {
        await fetchInitialData(isMock: isMock)
    }
}

@Observable @MainActor
final class InitialViewModel: InitialViewModelProtocol {
    var devices: [Device]
    var playingItems: [NowPlayingItem]
    var errorMessage: String?
    var fetchDataState: FetchDataState
    
    private let deviceService: DeviceServiceProtocol
    private let playService: PlayServiceProtocol
    private let fileService: FileServiceProtocol
    
    init(
        devices: [Device] = [],
        playingItems: [NowPlayingItem] = [],
        errorMessage: String? = nil,
        fetchDataState: FetchDataState = .idle,
        deviceService: DeviceServiceProtocol = DeviceService(),
        playService: PlayServiceProtocol = PlayService(),
        fileService: FileServiceProtocol = FileService()
    ) {
        self.devices = devices
        self.playingItems = playingItems
        self.errorMessage = errorMessage
        self.fetchDataState = fetchDataState
        
        self.deviceService = deviceService
        self.playService = playService
        self.fileService = fileService
    }
    
    func fetchInitialData(isMock: Bool) async {
        fetchDataState = .loading
        errorMessage = nil
        
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
                
                fetchDataState = .done
            } catch {
                switch error {
                case let FileServiceError.assetNotFound(fileName: fileName):
                    appendError("Asset not found: \(fileName)")
                case let FileServiceError.decodingFailed(error):
                    appendError("Decoding error: \(error)")
                default:
                    appendError("Data fetch failed: \(error.localizedDescription)")
                }
                
                fetchDataState = .error
            }
        } else {
            // Mock off: get data from network
            print("Get from network !!!")
            do {
                // Concurrently the two requests for device info and play info
                async let deviceRequest: () = fetchDevices()
                async let playRequest: () = fetchPlayItems()
                
                // Wait for both complete
                let _ = try await (deviceRequest, playRequest)
                
                fetchDataState = .done
            } catch {
                appendError("Data fetch failed: \(error.localizedDescription)")
                fetchDataState = .error
            }
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
            errorMessage = "\(existingError)\n\n\(message)"
        } else {
            errorMessage = message
        }
    }
}
