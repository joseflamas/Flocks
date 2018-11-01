//
//  Schedule.swift
//  BirdsFlock
//
//  Created by Guillermo Irigoyen on 10/21/18.
//  Copyright © 2018 Guillermo Irigoyen. All rights reserved.
//

import Foundation
import CoreLocation


enum ScheduleStatus {
    case working
    case halted
    case ended
    case invalid
    case canceled
    
    var description : String {
        switch self {
            case .working:  return "working"
            case .halted:   return "halted"
            case .ended:    return "ended"
            case .invalid:  return "invalid"
            case .canceled: return "canceled"
        }
    }
}


struct Schedule {
    
    // Name
    private(set) var scheduleId  : String!           // Destiny_FlockId
    // Flock
    private(set) var flock       : Flock!            // Flock( 111111, 50 )
    // Location
    private(set) var originCity  : City!             // City( "Austin", 30.305804, -97.728682, (lat, lon) , 500, 0 )
    private(set) var destinyCity : City!             // City( "Austin", 30.305804, -97.728682, (lat, lon) , 500, 0 )
    private(set) var latitude    : Double!
    private(set) var longitude   : Double!
    private(set) var locationCoordinate : CLLocationCoordinate2D!
    // Time
    private(set) var startDate   : Date!             // "2018-08-31T00:44:40+00:00" -> Aug, 08 2018 12:44 AM
    private(set) var endDate     : Date!             // "2018-08-31T00:44:40+00:00" -> Aug, 09 2018 12:44 AM
    // Status
    private(set) var status      : ScheduleStatus!
    
    /// Shchedule for a given Flock, a way to coordinate flock travels
    ///
    /// - Parameters:
    ///   - aFlock: a group or a batch of birds
    ///   - aCity: city to deliver to
    ///   - aStartDate: starting date for the trip
    ///   - anEndDate: ending date dor the trip
    init(forFlock aFlock:Flock,
                     toCity aCity:City,
                     fromStartingDate aStartDate:String,
                     toEndingDate anEndDate:String){
        // Flock
        flock       = aFlock
        // Location
        originCity  = USERDEFAULTCITY
        destinyCity = aCity
        setFirstLocation(latitude: USERDEFAULTCITY.latitude, longitude: USERDEFAULTCITY.longitude)   // LA
        // Time
        startDate   = ISO8601DateFormatter().date(from: aStartDate)//aStartDate
        endDate     = ISO8601DateFormatter().date(from: anEndDate) //anEndDate
        // Status
        status      = .working
        // Name
        scheduleId  = destinyCity.name+"_"+String(flock.id)

    }

    /// Location
    // SET
    mutating func setFirstLocation(latitude aLatitude:Double, longitude aLongitude:Double){
        latitude  = aLatitude
        longitude = aLongitude
        locationCoordinate = CLLocationCoordinate2DMake(latitude, longitude)
        print("SCHEDULE: Original location set.")
    }
    
    // UPDATE
    mutating func updateLocation(latitude aLatitude:Double, longitude aLongitude:Double){
        locationCoordinate = CLLocationCoordinate2DMake(latitude, longitude)
        print("SCHEDULE: Location updated.")
    }
    
    /// City
    // ORIGIN
    mutating func updateOriginCity(toCity newCity:City){
        originCity = newCity
        setFirstLocation(latitude: originCity.latitude, longitude: originCity.longitude)
        print("SCHEDULE: Origin updated.")
    }
    
    // DESTINY
    mutating func updateDestinyCity(toCity newCity:City){
        destinyCity = newCity
        scheduleId  = destinyCity.name+"_"+String(flock.id)
        print("SCHEDULE: Destiny updated.")
    }
    
    /// Time
    // START TIME
    mutating func updateStartDate(startDate aDate:Date){
        if confirmDates(startDate: aDate, endDate: endDate){
            startDate = aDate
            print("SCHEDULE: Schedule Start Date Updated.")
        
        } else {
            print("SCHEDULE ERROR: Invalid start date")
        }
        
    }
    
    // END TIME
    mutating func updateEndDate(endDate aDate:Date){
        if confirmDates(startDate: startDate, endDate: aDate){
            endDate = aDate
            print("SCHEDULE: Schedule End Date Updated.")
        
        } else {
            print("SCHEDULE ERROR: Invalid end date")
        }
        
    }
    
    // Check
    private func confirmDates(startDate aStartDate:Date, endDate anEndDate:Date) -> Bool {
        return true
    }
    
    /// Status
    // UPDATE
    mutating func updateStatus(status aNewStatus:ScheduleStatus){
        status = aNewStatus
        print("SCHEDULE: Schedule Status updated to \(aNewStatus).")
    }
    
}


