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
    @Environment(\.shareViewModel) var shareVM: ShareViewModelProtocol
    @Environment(\.playViewModel) var playVM: PlayViewModelProtocol

    var body: some View {
        VStack {
            TabView(selection: Binding(
                get: { shareVM.selectedTab },
                set: { newValue in
                    shareVM.selectedTab = newValue
                }
            )) {
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
            }
            .tint(.red)
        }
        .environment(\.shareViewModel, shareVM)
        .environment(\.playViewModel, playVM)
    }
}

#Preview("default mock on") {
    let mockShareVM = MockShareViewModel(isMock: true)
    
    MainScreen()
        .environment(\.shareViewModel, mockShareVM)
}

#Preview("default mock off") {
    let mockShareVM = MockShareViewModel(isMock: false)
    
    MainScreen()
        .environment(\.shareViewModel, mockShareVM)
}
