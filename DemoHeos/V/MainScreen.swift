//
//  MainScreen.swift
//  DemoHeos
//
//  Created by Armstrong Liu on 28/11/2024.
//

import SwiftUI

enum Tab {
    case home
    case room
    case setting
}

struct MainScreen: View {
    @State private var selectedTab: Tab = .room // Default select 'room'
    
    init(selectedTab: Tab = .room) {
        self.selectedTab = selectedTab
    }
    
    var body: some View {
        VStack {
            TabView(selection: $selectedTab) {
                HomeScreen()
                    .tabItem {
                        Label {
                            Text("Play")
                        } icon: {
                            Image("tabbar_icon_now_playing")
                                .renderingMode(.template)
                        }
                    }
                    .tag(Tab.home)
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
    }
}

#Preview {
    MainScreen()
}
