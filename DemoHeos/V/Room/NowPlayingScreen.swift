//
//  NowPlayingScreen.swift
//  DemoHeos
//
//  Created by Armstrong Liu on 28/11/2024.
//

import SwiftUI

struct NowPlayingScreen: View {
    @Binding var playVM: PlayViewModelProtocol
    @State private var seek: Double = 0
    
    let device: Device
    let nowPlayingItem: NowPlayingItem?
    
    var body: some View {
        let currentPlayState = playVM.getPlayState(for: device.id ?? 0)
        
        VStack {
            MyWebImage(imgUrl: nowPlayingItem?.artworkLarge)
                .frame(width: 300, height: 300)
                .cornerRadius(10)
            
            Slider(value: $seek, in: 0...100)
                .padding(.horizontal, 40)
            
            HStack {
                VStack(alignment: .leading) {
                    Text(nowPlayingItem?.trackName ?? "")
                        .font(.title)
                    Text(nowPlayingItem?.artistName ?? "")
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
                    playVM.updatePlayState(for: device.id ?? 0, to: currentPlayState == .playing ? .paused : .playing)
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
            
            Text(device.name ?? "")
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.top, 50)
            
            Spacer()
        }
        .toolbar(.hidden, for: .tabBar)
        .onAppear()
        .onDisappear() {
            playVM.showBrief = true
        }
    }
}

#Preview {
    NowPlayingScreen(
        playVM: .constant(PlayViewModel()),
        device: Device(id: 1, name: "test"),
        nowPlayingItem: NowPlayingItem(
            deviceID: 1,
            artworkSmall: nil,
            artworkLarge: nil,
            trackName: "test track",
            artistName: "test artist"
        )
    )
}
