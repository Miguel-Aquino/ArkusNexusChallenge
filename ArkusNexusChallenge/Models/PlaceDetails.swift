//
//  PlaceDetails.swift
//  ArkusNexusChallenge
//
//  Created by Miguel Aquino on 23/12/20.
//

import Foundation

struct PlaceDetails {
    var detail: PlaceType
    var detailValue: String
}

enum PlaceType {
    case directions
    case call
    case visitWebsite
    
    var value : String {
        switch self {
        case .directions:
            return "Directions"
        case .call:
            return "Call"
        case .visitWebsite:
            return "Visit Website"
        }
    }
}
