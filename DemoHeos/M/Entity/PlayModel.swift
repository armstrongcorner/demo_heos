//
//  PlayResponse.swift
//  DemoHeos
//
//  Created by Armstrong Liu on 27/11/2024.
//

import Foundation

struct PlayModel: Codable, Sendable {
    let nowPlaying: [NowPlayingItem]?

    enum CodingKeys: String, CodingKey {
        case nowPlaying = "Now Playing"
    }
}

struct NowPlayingItem: Codable, Sendable {
    let deviceID: Int?
    let artworkSmall: String?
    let artworkLarge: String?
    let trackName: String?
    let artistName: String?

    enum CodingKeys: String, CodingKey {
        case deviceID = "Device ID"
        case artworkSmall = "Artwork Small"
        case artworkLarge = "Artwork Large"
        case trackName = "Track Name"
        case artistName = "Artist Name"
    }
}

typealias PlayResponse = PlayModel
