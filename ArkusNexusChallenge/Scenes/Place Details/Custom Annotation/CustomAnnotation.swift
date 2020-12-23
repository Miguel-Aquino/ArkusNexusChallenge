//
//  CustomAnnotation.swift
//  ArkusNexusChallenge
//
//  Created by Miguel Aquino on 23/12/20.
//

import Foundation
import MapKit

class CustomAnnotation: MKPointAnnotation {
    var annotationName: String
    
    init(_ annotationName: String) {
        self.annotationName = annotationName
    }
}
