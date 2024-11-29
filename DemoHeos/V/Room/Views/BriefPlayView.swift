//
//  BriefPlayView.swift
//  DemoHeos
//
//  Created by Armstrong Liu on 29/11/2024.
//

import SwiftUI

struct BriefPlayView: View {
    @Binding var playVM: PlayViewModelProtocol
    
    let selectedDevice: Device
    let playItem: NowPlayingItem?
    
    var body: some View {
        let currentPlayState = playVM.getPlayState(for: selectedDevice.id ?? 0)
        HStack {
            MyWebImage(imgUrl: playItem?.artworkSmall)
                .frame(width: 50, height: 50)
                .cornerRadius(5)
                .padding(.leading, 10)
            
            VStack(alignment: .leading) {
                Text(playItem?.trackName ?? "Unknown Track")
                    .font(.headline)
                Text(playItem?.artistName ?? "Unknow Track")
                    .font(.subheadline)
            }
            .padding(.leading, 10)
            
            Spacer()
            
            Button {
                playVM.updatePlayState(for: selectedDevice.id ?? 0, to: currentPlayState == .playing ? .paused : .playing)
            } label: {
//                Image(systemName: currentPlayState == .playing ? "pause.fill" : "play.fill")
//                    .resizable()
//                    .frame(width: 30, height: 30)
                Image(currentPlayState == .playing ? "now_playing_controls_pause" : "now_playing_controls_play")
                    .resizable()
                    .frame(width: 30, height: 30)
            }
            .padding(.trailing, 30)
            
        }
        .frame(maxWidth: .infinity, minHeight: 80, maxHeight: 80)
        .background(Color(UIColor.secondarySystemBackground))
    }
}

#Preview {
    BriefPlayView(
        playVM: .constant(PlayViewModel()),
        selectedDevice: Device(id: 1, name: "test"),
        playItem: NowPlayingItem(
            deviceID: 1,
            artworkSmall: nil,
            artworkLarge: nil,
            trackName: "test track",
            artistName: "test artist"
        )
    )
}
