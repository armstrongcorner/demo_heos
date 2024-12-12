//
//  NowPlayingScreen.swift
//  DemoHeos
//
//  Created by Armstrong Liu on 28/11/2024.
//

import SwiftUI

struct NowPlayingScreen: View {
    @Environment(\.playViewModel) var playVM: PlayViewModelProtocol
    
    @State private var seek: Double = 0
    
    var body: some View {
        let currentPlayState = playVM.getCurrentPlayState()
        
        if currentPlayState != nil {
            VStack {
                MyWebImage(imgUrl: playVM.selectedPlayingItem?.artworkLarge)
                    .frame(width: 300, height: 300)
                    .cornerRadius(10)
                
                Slider(value: $seek, in: 0...100)
                    .padding(.horizontal, 40)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text(playVM.selectedPlayingItem?.trackName ?? "")
                            .font(.title)
                        Text(playVM.selectedPlayingItem?.artistName ?? "")
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 40)
                .padding(.top, 10)
                
                HStack {
                    Button {
                        print("Prev clicked")
                    } label: {
                        Image(systemName: "backward.end.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                    .padding(.trailing, 30)
                    
                    Button {
                        playVM.updateCurrentPlayState(newState: currentPlayState == .playing ? .paused : .playing)
                    } label: {
                        Image(currentPlayState == .playing ? "now_playing_controls_pause" : "now_playing_controls_play")
                            .resizable()
                            .frame(width: 50, height: 50)
                    }
                    .padding(.trailing, 30)
                    
                    Button {
                        print("Prev clicked")
                    } label: {
                        Image(systemName: "forward.end.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                }
                .padding(.top, 40)
                
                Text(playVM.selectedDevice?.name ?? "")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.top, 50)
                
                Spacer()
            }
            .onDisappear() {
                playVM.showBrief = true
            }
        } else {
            VStack {
                Text("No room selected yet")
            }
        }
    }
}

#Preview("selected one") {
    let mockPlayVM = PlayViewModel(
        devices: [mockDevice1, mockDevice2, mockDevice3],
        selectedDevice: mockDevice1,
        selectedPlayingItem: mockNowPlayingItem1
    )
    
    NowPlayingScreen()
        .environment(\.playViewModel, mockPlayVM)
        .tint(.black)
}

#Preview("real") {
    let playVM = PlayViewModel()
    
    NowPlayingScreen()
        .environment(\.playViewModel, playVM)
        .tint(.black)
}
