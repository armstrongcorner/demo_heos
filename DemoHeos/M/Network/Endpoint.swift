//
//  Endpoint.swift
//  DemoHeos
//
//  Created by Armstrong Liu on 27/11/2024.
//

import Foundation

enum Endpoint {
    static let baseURL = "https://skyegloup-eula.s3.amazonaws.com/heos_app/code_test"
    
    case deviceInfo
    case playInfo
    
    var url: URL {
        switch self {
        case .deviceInfo:
            return URL(string: "\(Endpoint.baseURL)/devices.json")!
        case .playInfo:
            return URL(string: "\(Endpoint.baseURL)/nowplaying.json")!
        }
    }
}
