//
//  RoomScreen.swift
//  DemoHeos
//
//  Created by Armstrong Liu on 28/11/2024.
//

import SwiftUI

struct RoomScreen: View {
    @Environment(\.shareViewModel) var shareVM: ShareViewModelProtocol
    @Environment(\.playViewModel) var playVM: PlayViewModelProtocol
    
    @State private var initialVM: InitialViewModelProtocol
    
    init(initialVM: InitialViewModelProtocol = InitialViewModel()) {
        self.initialVM = initialVM
    }

    var body: some View {
        VStack {
            switch initialVM.fetchDataState {
            case .done:
                Text("Drag one room into another to group them")
                    .font(.subheadline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                RoomListView(
                    devices: initialVM.devices,
                    playingItems: initialVM.playingItems
                )
                
                Spacer()
                
//                if playVM.showBrief {
                if playVM.selectedDevice != nil && playVM.showBrief {
                    // Show the current selected device
                    BriefPlayView()
                }
            case .loading:
                ProgressView("Loading")
                    .progressViewStyle(CircularProgressViewStyle())
            case .error:
                Text("Error:\n\(initialVM.errorMessage ?? "")")
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
                Button("Retry") {
                    fetchInitData()
                }
                .buttonStyle(.borderedProminent)
            case .idle:
                EmptyView()
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
        .onAppear() {
            if shareVM.refreshData {
                // Force retrive when app launch
                fetchInitData()
                shareVM.refreshData = false
            }
        }
        .tint(.black)
    }
    
    private func fetchInitData() {
        Task {
            await initialVM.fetchInitialData()
            playVM.initializePlayStates(with: initialVM.devices)
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
    var fetchDataState: FetchDataState
    
    init(
        devices: [Device] = [],
        playingItems: [NowPlayingItem] = [],
        errorMessage: String? = nil,
        fetchDataState: FetchDataState = .loading
    ) {
        self.devices = devices
        self.playingItems = playingItems
        self.errorMessage = errorMessage
        self.fetchDataState = fetchDataState
    }
    
    func fetchInitialData() async {
        // Mock keep loading
        try? await Task.sleep(nanoseconds: 1_000_000_000)
    }
}
