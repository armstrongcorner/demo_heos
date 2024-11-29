//
//  RoomListView.swift
//  DemoHeos
//
//  Created by Armstrong Liu on 29/11/2024.
//

import SwiftUI

struct RoomListView: View {
    let devices: [Device]
    let playingItems: [NowPlayingItem]
    
    @Binding var playVM: PlayViewModelProtocol
    @Binding var selectedDevice: Device?
    @Binding var selectedPlayItem: NowPlayingItem?
    @Binding var path: [Route]
    
    var body: some View {
        List(devices, id: \.id) { device in
            Button {
                selectedDevice = device
                selectedPlayItem = playingItems.first { $0.deviceID == device.id }
                playVM.showBrief = false
                
                path.append(.nowPlayingScreen)
            } label: {
                let deviceName = device.name ?? "Unknown Device"
                let nowPlayItem = playingItems.first { $0.deviceID == device.id }
                let playState = playVM.getPlayState(for: device.id ?? 0)
                
                RoomListItem(
                    imageUrl: nowPlayItem?.artworkSmall ?? "",
                    deviceName: deviceName,
                    trackName: nowPlayItem?.trackName ?? "",
                    playState: playState,
                    isSelected: selectedDevice?.id == device.id
                )
            }
            .listRowSeparator(.hidden)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
        }
        .listStyle(.plain)
    }
}

#Preview {
    RoomListView(
        devices: [Device(id: 1, name: "test1"), Device(id: 2, name: "test2"), Device(id: 3, name: "test3")],
        playingItems: [NowPlayingItem(deviceID: 1, artworkSmall: nil, artworkLarge: nil, trackName: "test track", artistName: "test artist")],
        playVM: .constant(PlayViewModel()),
        selectedDevice: .constant(Device(id: 1, name: "test")),
        selectedPlayItem: .constant(NowPlayingItem(deviceID: 1, artworkSmall: nil, artworkLarge: nil, trackName: "test track", artistName: "test artist")),
        path: .constant([])
    )
}
