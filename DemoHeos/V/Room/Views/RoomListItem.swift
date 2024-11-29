//
//  RoomListItem.swift
//  DemoHeos
//
//  Created by Armstrong Liu on 28/11/2024.
//

import SwiftUI

struct RoomListItem: View {
    let imageUrl: String
    let deviceName: String
    let trackName: String
    let playState: PlayState
    let isSelected: Bool
        
    var body: some View {
        HStack {
            MyWebImage(imgUrl: imageUrl)
                .frame(width: 50, height: 50)
                .cornerRadius(5)
                .padding(.leading, 10)
            
            VStack(alignment: .leading) {
                Spacer()
                Text(deviceName)
                    .font(.headline)
                HStack {
                    Image(systemName: imageName(for: playState))
                        .resizable()
                        .frame(width: 13, height: 13)
                        .padding(.leading, 8)
                    
                    Text(trackName)
                        .font(.subheadline)
                }
                Spacer()
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, minHeight: 80, maxHeight: 80)
        .background(isSelected ? Color.gray : Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
    
    private func imageName(for state: PlayState) -> String {
        switch state {
        case .playing:
            return "chart.bar.xaxis"
        case .paused:
            return "pause.fill"
        case .stopped:
            return "stop.fill"
        }
    }
}

#Preview {
    Group {
        RoomListItem(
            imageUrl: "",
            deviceName: "test device1",
            trackName: "test sound track1",
            playState: .stopped,
            isSelected: false
        )
        
        RoomListItem(
            imageUrl: "",
            deviceName: "test device2",
            trackName: "test sound track2",
            playState: .playing,
            isSelected: true
        )

        RoomListItem(
            imageUrl: "",
            deviceName: "test device3",
            trackName: "test sound track3",
            playState: .paused,
            isSelected: false
        )
    }
}
