//
//  Place.swift
//  ArkusNexusChallenge
//
//  Created by Miguel Aquino on 22/12/20.
//

import Foundation

struct Place: Decodable {
    let PlaceId: String
    let PlaceName: String
    let Address: String
    let Category: String
    let IsOpenNow: String
    let Latitude: Double
    let Longitude: Double
    let Thumbnail: String
    let Rating: Double
    let IsPetFriendly: Bool
    let AddressLine1: String
    let AddressLine2: String
    let PhoneNumber: String
    let Site: String
}
