//
//  PlaceViewModel.swift
//  ArkusNexusChallenge
//
//  Created by Miguel Aquino on 22/12/20.
//

import Foundation
import  CoreLocation

class PlaceViewModel {
    //MARK:- Properties
    private var place: Place
    
    init(_ place: Place) {
        self.place = place
        distance = Double()
        currentLocation = CLLocationCoordinate2D()
    }
    
    var PlaceId: String {
        return place.PlaceId
    }
    
    var PlaceName: String {
        return place.PlaceName
    }
    
    var Address: String {
        return place.Address
    }
    
    var Category: String {
        return place.Category
    }
    
    var IsOpenNow: String {
        return place.IsOpenNow
    }
    var Latitude: Double {
        return place.Latitude
    }
    
    var Longitude: Double {
        return place.Longitude
    }
    
    var Thumbnail: String {
        return place.Thumbnail
    }
    
    var Rating: Double {
        return place.Rating
    }
    
    var IsPetFriendly: Bool {
        return place.IsPetFriendly
    }
    
    var AddressLine1: String {
        return place.AddressLine1
    }
    
    var AddressLine2: String {
        return place.AddressLine2
    }
    
    var PhoneNumber: String {
        return place.PhoneNumber
    }
    
    var Site: String {
        return place.Site
    }
    
    var currentLocation: CLLocationCoordinate2D
    
    var distance: Double

    
    func calculateDistance(currentLocation: CLLocationCoordinate2D){
        let placeLocation = CLLocation(latitude: Latitude,
                                       longitude: Longitude)
        
        let currentLocation = CLLocation(latitude: currentLocation.latitude,
                                         longitude: currentLocation.longitude)
        
        let distance = currentLocation.distance(from: placeLocation)
                
        self.distance = distance
    }
}

