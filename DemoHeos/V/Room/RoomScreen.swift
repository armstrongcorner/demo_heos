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
        NavigationView {
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
        }
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

#Preview("from network") {
    let mockInitialVM = MockInitialViewModel()
    
    RoomScreen(initialVM: mockInitialVM)
}

#Preview("from local") {
    let mockInitialVM = MockInitialViewModel(shouldUseMockData: true)
    
    RoomScreen(initialVM: mockInitialVM)
}

#Preview("selected one") {
    let mockInitialVM = MockInitialViewModel(shouldUseMockData: true)
    let mockPlayVM = PlayViewModel(
        devices: [mockDevice1, mockDevice2, mockDevice3],
        selectedDevice: mockDevice1,
        selectedPlayingItem: mockNowPlayingItem1,
        showBrief: true
    )
    
    RoomScreen(initialVM: mockInitialVM)
        .environment(\.playViewModel, mockPlayVM)
}

#Preview("keep loading") {
    let mockInitialVM = MockInitialViewModel(shouldKeepLoading: true)
    
    RoomScreen(initialVM: mockInitialVM)
}

#Preview("error") {
    let mockInitialVM = MockInitialViewModel(shouldReturnError: true)
    
    RoomScreen(initialVM: mockInitialVM)
}

#Preview("real") {
    let initialVM = InitialViewModel()
    
    RoomScreen(initialVM: initialVM)
}
