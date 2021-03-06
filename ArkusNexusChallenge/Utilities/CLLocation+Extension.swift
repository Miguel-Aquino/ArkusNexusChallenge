//
//  CLLocation+Extension.swift
//  ArkusNexusChallenge
//
//  Created by Miguel Aquino on 23/12/20.
//

import CoreLocation

extension CLLocationCoordinate2D {
    func distance(from: CLLocationCoordinate2D) -> CLLocationDistance {
        let from = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let to = CLLocation(latitude: self.latitude, longitude: self.longitude)
        return from.distance(from: to)
    }
}
