//
//  DeviceModel.swift
//  DemoHeos
//
//  Created by Armstrong Liu on 27/11/2024.
//

import Foundation

struct DeviceModel: Codable, Sendable {
    let devices: [Device]?

    enum CodingKeys: String, CodingKey {
        case devices = "Devices"
    }
}

struct Device: Identifiable, Codable, Sendable {
    let id: Int?
    let name: String?

    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case name = "Name"
    }
}

typealias DeviceResponse = DeviceModel
