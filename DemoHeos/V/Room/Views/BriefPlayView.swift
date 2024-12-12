//
//  BriefPlayView.swift
//  DemoHeos
//
//  Created by Armstrong Liu on 29/11/2024.
//

import SwiftUI

struct BriefPlayView: View {
    @Environment(\.playViewModel) var playVM: PlayViewModelProtocol
    
    var body: some View {
        let currentPlayState = playVM.getCurrentPlayState()
        
        HStack {
            MyWebImage(imgUrl: playVM.selectedPlayingItem?.artworkSmall)
                .frame(width: 50, height: 50)
                .cornerRadius(5)
                .padding(.leading, 10)
            
            VStack(alignment: .leading) {
                Text(playVM.selectedPlayingItem?.trackName ?? "Unknown Track")
                    .font(.headline)
                Text(playVM.selectedPlayingItem?.artistName ?? "Unknow Track")
                    .font(.subheadline)
            }
            .padding(.leading, 10)
            
            Spacer()
            
            Button {
                playVM.updateCurrentPlayState(newState: currentPlayState == .playing ? .paused : .playing)
            } label: {
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
    let mockPlayVM = PlayViewModel(
        devices: [mockDevice1, mockDevice2, mockDevice3],
        selectedDevice: mockDevice1,
        selectedPlayingItem: mockNowPlayingItem1
    )
    
    BriefPlayView()
        .environment(\.playViewModel, mockPlayVM)
}
