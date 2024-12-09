//
//  MainScreen.swift
//  DemoHeos
//
//  Created by Armstrong Liu on 28/11/2024.
//

import SwiftUI

enum Tab {
    case nowPlaying
    case room
    case setting
}

struct MainScreen: View {
    @State private var shareVM: ShareViewModelProtocol
    @State private var playVM: PlayViewModelProtocol
    
    init(
        shareVM: ShareViewModelProtocol = ShareViewModel(selectedTab: .room, refreshData: true),
        playVM: PlayViewModelProtocol = PlayViewModel()
    ) {
        self.shareVM = shareVM
        self.playVM = playVM
    }
    
    var body: some View {
        VStack {
            TabView(selection: $shareVM.selectedTab) {
                NowPlayingScreen()
                    .tabItem {
                        Label {
                            Text("Play")
                        } icon: {
                            Image("tabbar_icon_now_playing")
                                .renderingMode(.template)
                        }
                    }
                    .tag(Tab.nowPlaying)
                    .tint(.black)
                
                RoomScreen()
                    .tabItem {
                        Label {
                            Text("Rooms")
                        } icon: {
                            Image("tabbar_icon_block_rooms")
                                .renderingMode(.template)
                        }
                    }
                    .tag(Tab.room)
                    .tint(.black)
                
                SettingScreen()
                    .tabItem {
                        Label {
                            Text("Settings")
                        } icon: {
                            Image("tabbar_icon_settings")
                                .renderingMode(.template)
                        }
                    }
                    .tag(Tab.setting)
                    .tint(.black)
            }
            .tint(.red)
        }
        .environment(\.shareViewModel, shareVM)
        .environment(\.playViewModel, playVM)
    }
}

#Preview {
    MainScreen()
}
