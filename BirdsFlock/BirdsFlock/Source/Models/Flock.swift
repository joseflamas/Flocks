//
//  Flock.swift
//  BirdsFlock
//
//  Created by Guillermo Irigoyen on 10/21/18.
//  Copyright © 2018 Guillermo Irigoyen. All rights reserved.
//

import Foundation
import CoreLocation

enum FlockStatus {
    case ready
    case moving
    case halted
    case delivered
    
    var description : String {
        switch self {
            case .ready:     return "ready"
            case .moving:    return "moving"
            case .halted:    return "halted"
            case .delivered: return "delivered"
        }
    }
}

struct Flock {
    
    // Name
    private(set) var id    : Int!                                       // 1111111
    private(set) var count : Int!                                       // 100
    // Status
    private(set) var status : FlockStatus!                              // .ready
    // Location
    private(set) var originCity    : City!                              // City
    private(set) var latitude      : Double!                            // 34.048925
    private(set) var longitude     : Double!                            // -118.428663
    private(set) var locationCoordinate : CLLocationCoordinate2D!       // (lat, lon)
    // Schedules
    private(set) var schedules     : [String] = [String]()              // [ScheduleId]
    
    /// Flock a batch of birds
    ///
    /// - Parameters:
    ///   - anId: id to identify the flock
    ///   - aCount: number of memebers in the flock
    init(id anId:Int, count aCount:Int){
        // Name
        id    = anId
        count = aCount
        // Status
        status = .ready
        // Location, user by default
        originCity = USERDEFAULTCITY
        latitude   = Double(originCity.latitude)
        longitude  = Double(originCity.longitude)
        locationCoordinate = CLLocationCoordinate2DMake(latitude, longitude)
    }
    
    /// Status
    // UPDATE
    mutating func updateStatus(status aNewStatus:FlockStatus){
        status = aNewStatus
        print("FLOCK: Flock Status updated to \(aNewStatus.description).")
    }
    
    /// Location
    // SET ORIGIN CITY
    mutating func setOriginCity(toCity aCity: City){
        // Flocks and Schedules must have same originCity in this app
        originCity = aCity
        latitude  = Double(originCity.latitude)
        longitude = Double(originCity.longitude)
        locationCoordinate = CLLocationCoordinate2DMake(latitude, longitude)

    }
    
    // UPDATE
    mutating func updateLocation(latitud aLatitude:Double, longitude aLongitude:Double){
        locationCoordinate = CLLocationCoordinate2DMake(latitude, longitude)
        print("FLOCK: Location updated.")
    }
    
    /// Schedules
    // Add
    mutating func addSchedule(schedule aNewSchedule:Schedule){
        if schedules.index(of: aNewSchedule.scheduleId) != nil{
            print("FLOCK: Schedule already exist for  for flock")
            updateSchedule(schedule: aNewSchedule)
            
        } else {
            schedules.append(aNewSchedule.scheduleId)
            print("FLOCK: New schedule for flock added.")
        }
        
    }
    
    // Update
    mutating func updateSchedule(schedule anScheduleToUpdate:Schedule){
        if let scheduleIndex = schedules.index(of: anScheduleToUpdate.scheduleId){
            schedules[scheduleIndex] = anScheduleToUpdate.scheduleId
            print("FLOCK: Schedule for flock updated.")
        } else {
            print("FLOCK ERROR: Could not find schedule for flock, nothing to update.")
        }
    }
    
    // Remove
    mutating func removeSchedule(schedule anScheduleToRemove:Schedule){
        if let scheduleIndex = schedules.index(of: anScheduleToRemove.scheduleId){
            schedules.remove(at: scheduleIndex)
            print("FLOCK: Schedule for flock removed.")
        } else {
            print("FLOCK ERROR: Could not find schedule for flock, nothing to remove.")
        }
    }
    

}

