//
//  City.swift
//  BirdsFlock
//
//  Created by Guillermo Irigoyen on 10/21/18.
//  Copyright © 2018 Guillermo Irigoyen. All rights reserved.
//

import Foundation
import CoreLocation

struct City {
    
    // Name
    private(set) var name          : String!               // Los Angeles
    // Location
    private(set) var latitude      : Double!                            // 34.048925
    private(set) var longitude     : Double!                            // -118.428663
    private(set) var locationCoordinate : CLLocationCoordinate2D!       // (lat, lon)
    // Capacity
    private(set) var capacity      : Int! {                             // 500
        didSet{
            updateCapacity()
        }
    }
    private(set) var capacityTaken : Int! {                             // 50
        didSet{
            updateCapacity()
        }
    }
    private(set) var capacityLeft  : Float!                             // 0.1 % (0.0 - 1.0)
    // Schedules
    private(set) var schedules     : [String] = [String]()              // [Schedule]
    
    /// Convenience Initializer,
    ///
    /// - Parameters:
    ///   - aName: Name of the city
    ///   - aLatitude: Latitude of the city
    ///   - aLongitude: Longitude of the city
    ///   - aCapacity: Capacity limit in case government limitation exists
    init(name aName:String,
                     latitude aLatitude:Float,
                     longitude aLongitude:Float,
                     capacity aCapacity:Int = 0) {
        // Name
        name      = aName.lowercased()
        // Location
        latitude  = Double(aLatitude)
        longitude = Double(aLongitude)
        locationCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        // Capacity
        capacity      = aCapacity
        capacityTaken = 0
        capacityLeft  = aCapacity > 0 ? Float(capacityTaken)/Float(capacity) : 1.0
        
    }
    
    /// Capacity
    // new
    mutating func changeCapacity(newCapacity aNewCapacity:Int){
        capacity = aNewCapacity
    }
    
    func hasSpacefor(capacity someCapacity:Int) -> Bool {
        if capacity == 0 || (capacity > 0 && (capacity - someCapacity) >= 0) {
            return true
        }
        return false
    }
    
    // reserve
    mutating func reserveCapacity(capacity someCapacity:Int) -> Bool {
        let newReservedCapacity = (capacityTaken + someCapacity)
        if capacity > 0 && newReservedCapacity < capacity {
            capacityTaken = capacityTaken + newReservedCapacity
            print("CITY: \(String(capacityTaken)) City capacity reserved.")
            return true
        } else if capacity == 0 {
            print("CITY: The capacity for the city is unlimied")
            return true
        } else {
            print("CITY ERROR: \(TEXT_CITY_WRONG_CAPACITY_MESSAGE)")
            return false
        }
    }
    
    // recover
    mutating func recoverCapacity(capacity someCapacity:Int) -> Bool {
        if capacity > 0 && capacityTaken > 0 && (capacityTaken - someCapacity) >= 0 && someCapacity < capacity {
            capacityTaken = capacityTaken - someCapacity
            print("CITY: \(String(capacityTaken)) City capacity recovered.")
            return true
        } else if capacity == 0 {
            print("CITY: Full capacity")
            return true
        } else {
            print("CITY ERROR: \(TEXT_CITY_WRONG_CAPACITY_MESSAGE)")
            return false
        }
    }
    
    // update
    mutating func updateCapacity(){
        print("CITY: City capacity updated.")
        capacityLeft = capacity > 0 ? Float(capacityTaken)/Float(capacity) : 1.0
    }
    
    /// Schedules
    // Add
    mutating func addSchedule(schedule aNewSchedule:Schedule){
        if schedules.index(of: aNewSchedule.scheduleId) != nil {
            print("CITY: Schedule already exist for city.")
            updateSchedule(schedule: aNewSchedule)
            
        } else {
            schedules.append(aNewSchedule.scheduleId)
            print("CITY: New schedule for city added.")
        }
        
    }
    
    // Update
    mutating func updateSchedule(schedule anScheduleToUpdate:Schedule){
        if let scheduleIndex = schedules.index(of: anScheduleToUpdate.scheduleId){
            schedules[scheduleIndex] = anScheduleToUpdate.scheduleId
            print("CITY: Schedule for city updated.")
        } else {
            print("CITY ERROR: Could not find schedule for city, nothing to update.")
        }
    }
    
    // Remove
    mutating func removeSchedule(schedule anScheduleToRemove:Schedule){
        if let scheduleIndex = schedules.index(of: anScheduleToRemove.scheduleId){
            schedules.remove(at: scheduleIndex)
            print("CITY: Schedule for city removed.")
        } else {
            print("CITY ERROR: Could not find schedule for city, nothing to remove.")
        }
    }
    
}

