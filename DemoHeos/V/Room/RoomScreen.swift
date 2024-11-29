//
//  RoomScreen.swift
//  DemoHeos
//
//  Created by Armstrong Liu on 28/11/2024.
//

import SwiftUI

struct RoomScreen: View {
    @State private var path: [Route] = []
    @State private var isFirstLoad: Bool = true
    @State private var initialVM: InitialViewModelProtocol
    @State private var playVM: PlayViewModelProtocol
    @State private var selectedDevice: Device?
    @State private var selectedPlayItem: NowPlayingItem?
    
    init(
        initialVM: InitialViewModelProtocol = InitialViewModel(),
        playVM: PlayViewModelProtocol = PlayViewModel()
    ) {
        self.initialVM = initialVM
        self.playVM = playVM
    }

    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                if !initialVM.isLoading && initialVM.errorMessage == nil {
                    Text("Drag one room into another to group them")
                        .font(.subheadline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)

                    RoomListView(
                        devices: initialVM.devices,
                        playingItems: initialVM.playingItems,
                        playVM: $playVM,
                        selectedDevice: $selectedDevice,
                        selectedPlayItem: $selectedPlayItem,
                        path: $path
                    )
                    
                    Spacer()
                    
                    if let selectedDevice = selectedDevice, playVM.showBrief {
                        // Show the current selected device
                        BriefPlayView(
                            playVM: $playVM,
                            selectedDevice: selectedDevice,
                            playItem: selectedPlayItem
                        )
                    }
                } else if initialVM.isLoading {
                    ProgressView("Loading")
                        .progressViewStyle(CircularProgressViewStyle())
                } else if let errorMessage = initialVM.errorMessage {
                    Text("Error:\n\(errorMessage)")
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                    Button("Retry") {
                        fetchInitData(forceFetch: true)
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Button {
                        print("icon clicked")
                    } label: {
                        Image(systemName: "headphones.circle.fill")
                    }
                }
                
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        print("Edit clicked")
                    } label: {
                        Text("Edit")
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .navigationTitle("Rooms")
            .navigationDestination(for: Route.self) { value in
//                getViewByRoute(value)
                switch value {
                case .nowPlayingScreen:
                    NowPlayingScreen(
                        playVM: $playVM,
                        device: selectedDevice ?? Device(id: 0, name: "Unknown"),
                        nowPlayingItem: selectedPlayItem
                    )
                    .navigationTitle(selectedDevice?.name ?? "Unknown")
                    .navigationBarTitleDisplayMode(.inline)
                }
            }
            .onAppear() {
                if isFirstLoad {
                    // Force retrive when app launch
                    fetchInitData(forceFetch: true)
                    isFirstLoad = false
                } else if UserDefaults.standard.bool(forKey: CacheKey.needRefresh.rawValue) {
                    // Do retrieve as needed
                    fetchInitData()
                }
            }
        }
        .tint(.black)
//        .environment(\.myRoute, $path)
    }
    
    private func fetchInitData(forceFetch: Bool = false) {
        Task {
            if forceFetch || UserDefaults.standard.bool(forKey: CacheKey.needRefresh.rawValue) {
                selectedDevice = nil
                await initialVM.fetchInitialData()
                playVM.initializePlayStates(with: initialVM.devices)
                UserDefaults.standard.set(false, forKey: CacheKey.needRefresh.rawValue)
            }
        }
    }
}

#Preview {
    Group {
//        let mockInitialVM = MockInitialViewModel()
//        let mockInitialVM = MockInitialViewModel(errorMessage: "mock error msg", isLoading: false)
        let mockInitialVM = InitialViewModel()
        RoomScreen(initialVM: mockInitialVM)
    }
}

/*
 Mock the vm for preview here
 */
final class MockInitialViewModel: InitialViewModelProtocol {
    var devices: [Device]
    var playingItems: [NowPlayingItem]
    var errorMessage: String?
    var isLoading: Bool
    
    init(devices: [Device] = [],
         playingItems: [NowPlayingItem] = [],
         errorMessage: String? = nil,
         isLoading: Bool = true)
    {
        self.devices = devices
        self.playingItems = playingItems
        self.errorMessage = errorMessage
        self.isLoading = isLoading
    }
    
    func fetchInitialData() async {
        // Mock keep loading
        try? await Task.sleep(nanoseconds: 1_000_000_000)
    }
}
