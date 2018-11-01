//
//  FlocksExplorerMapAnnotation.swift
//  BirdsFlock
//
//  Created by Guillermo Irigoyen on 10/22/18.
//  Copyright © 2018 Guillermo Irigoyen. All rights reserved.
//

import Foundation
import MapKit

class FlocksExplorerMapAnnotation : NSObject, MKAnnotation {
    
    private(set) var mappableObject:     Any!
    private(set) var mappableObjectType: FlockMapAnnotationType!
    var coordinate:         CLLocationCoordinate2D
    
    init(data someData:Any, type aType:FlockMapAnnotationType) {
        
        mappableObjectType = aType
        
        switch mappableObjectType {
        case .some(.city):
            mappableObject = someData
            let city = mappableObject as! City
            coordinate = city.locationCoordinate
            break
            
        case .some(.flock):
            mappableObject = someData
            let flock = mappableObject as! Flock
            coordinate = flock.locationCoordinate
            break
            
        case .some(.schedule):
            mappableObject = someData
            let schedules = mappableObject as! Schedule
            coordinate = schedules.locationCoordinate
            break
            
        default:
            // México ;) this is never supposed to be reached
            coordinate = CLLocationCoordinate2D(latitude: 23.6345, longitude: -102.5528)
            break
            
        }
    }
    
}



