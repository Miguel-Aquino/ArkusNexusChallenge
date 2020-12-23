//
//  Constants.swift
//  ArkusNexusChallenge
//
//  Created by Miguel Aquino on 22/12/20.
//

import UIKit

enum VCs{
    static let placesVC = PlacesViewController(nibName: "PlacesViewController", bundle: nil)
    static let placeDetailsVC = PlaceDetailsViewController(nibName: "PlaceDetailsViewController", bundle: nil)
}

enum ApiURL {
    static let placesURL = "https://www.mocky.io/v2/5bf3ce193100008900619966"
}

enum Identifiers {
    static let pinSelected = "pinSelected"
}

enum Images {
    static let directions = UIImage(named: "icons8RouteFilled")
    static let call = UIImage(named: "cellIconsPhoneCopy1")
    static let visitWebSite = UIImage(named: "cellIconsWebsite")
}

enum PlaceInfo {
    static let directions = "Directions"
    static let call = "Call"
    static let visitWebsite = "Visit Website"
}
