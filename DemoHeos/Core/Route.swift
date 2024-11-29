//
//  Route.swift
//  DemoHeos
//
//  Created by Armstrong Liu on 28/11/2024.
//

import SwiftUI

enum Route: Hashable {
//    case mainScreen
//    case homeScreen
//    case roomScreen(email: String)
//    case roomScreen
    case nowPlayingScreen
//    case settingScreen

}

private struct MyRouteKey: EnvironmentKey {
    static let defaultValue: Binding<[Route]> = .constant([])
}

extension EnvironmentValues {
    var myRoute: Binding<[Route]> {
        get { self[MyRouteKey.self] }
        set { self[MyRouteKey.self] = newValue }
    }
}
//
//@MainActor var getViewByRoute: (Route) -> AnyView = { route in
//    switch route {
//    case .mainScreen:
//        return AnyView(MainScreen())
//    case .homeScreen:
//        return AnyView(HomeScreen())
////    case .roomScreen(let email):
////        return AnyView(RoomScreen(email: email))
//    case .roomScreen:
//        return AnyView(RoomScreen())
//    case .nowPlayingScreen:
//        return AnyView(NowPlayingScreen())
//    case .settingScreen:
//        return AnyView(SettingScreen())
//    }
//}
