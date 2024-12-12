//
//  MockData.swift
//  DemoHeosTests
//
//  Created by Armstrong Liu on 12/10/24.
//

import Foundation

let mockDevice1: Device = Device(id: 1, name: "Device 1")
let mockDevice2: Device = Device(id: 2, name: "Device 2")
let mockDevice3: Device = Device(id: 3, name: "Device 3")
let mockDevice4: Device = Device(id: 4, name: "Device 4")

let mockNowPlayingItem1: NowPlayingItem = NowPlayingItem(
    deviceID: 1,
    artworkSmall: "https://example.com/artwork_small_1.jpg",
    artworkLarge: "https://example.com/artwork_large_1.jpg",
    trackName: "Test Track 1",
    artistName: "Test Artist 1"
)
let mockNowPlayingItem2: NowPlayingItem = NowPlayingItem(
    deviceID: 2,
    artworkSmall: "https://example.com/artwork_small_2.jpg",
    artworkLarge: "https://example.com/artwork_large_2.jpg",
    trackName: "Test Track 2",
    artistName: "Test Artist 2"
)
let mockNowPlayingItem3: NowPlayingItem = NowPlayingItem(
    deviceID: 3,
    artworkSmall: "https://example.com/artwork_small_3.jpg",
    artworkLarge: "https://example.com/artwork_large_3.jpg",
    trackName: "Test Track 3",
    artistName: "Test Artist 3"
)
let mockNowPlayingItem4: NowPlayingItem = NowPlayingItem(
    deviceID: 4,
    artworkSmall: "https://example.com/artwork_small_4.jpg",
    artworkLarge: "https://example.com/artwork_large_4.jpg",
    trackName: "Test Track 4",
    artistName: "Test Artist 4"
)

let mockDevicesRawString: String = """
{
    "Devices": [{
        "ID": 1,
        "Name": "Sydney"
    }, {
        "ID": 2,
        "Name": "Beijing"
    }, {
        "ID": 3,
        "Name": "Auckland"
    }]
}
"""

let mockNowPlayingRawString: String = """
{
    "Now Playing": [{
        "Device ID": 1,
        "Artwork Small": "https://skyegloup-eula.s3.amazonaws.com/heos_app/code_test/Appetite+For+Destruction+-+small.jpg",
        "Artwork Large": "https://skyegloup-eula.s3.amazonaws.com/heos_app/code_test/Appetite+For+Destruction+-+large.jpg",
        "Track Name": "Test song 1",
        "Artist Name": "Test singer 1"
    }, {
        "Device ID": 2,
        "Artwork Small": "https://skyegloup-eula.s3.amazonaws.com/heos_app/code_test/Brothers+In+Arms+-+small.jpg",
        "Artwork Large": "https://skyegloup-eula.s3.amazonaws.com/heos_app/code_test/Brothers+In+Arms+-+large.jpg",
        "Track Name": "Test song 2",
        "Artist Name": "Test singer 2"
    }, {
        "Device ID": 3,
        "Artwork Small": "https://skyegloup-eula.s3.amazonaws.com/heos_app/code_test/Elephant+-+small.jpg",
        "Artwork Large": "https://skyegloup-eula.s3.amazonaws.com/heos_app/code_test/Elephant+-+large.jpg",
        "Track Name": "Test song 3",
        "Artist Name": "Test singer 3"
    }]
}
"""
