//
//  FlocksExplorerMapView.swift
//  BirdsFlock
//
//  Created by Guillermo Irigoyen on 10/21/18.
//  Copyright © 2018 Guillermo Irigoyen. All rights reserved.
//

import Foundation
import MapKit

/// Explorer Map
class FlocksExplorerMapView : MKMapView {
}

// Animations
extension FlocksExplorerMapView {
    
    // Show detail
    func centerMap() {
        // México ;)
        let annotationCoordinate = CLLocationCoordinate2D(latitude: 23.6345, longitude: -102.5528)
        UIView.animate(withDuration: 0.5, animations: {
            let viewRegion = MKCoordinateRegion(center: annotationCoordinate,
                                                latitudinalMeters: 7500000,
                                                longitudinalMeters: 7500000)
            self.setRegion(viewRegion, animated: true)

        })
    }

}
