//
//  DataManager.swift
//  BirdsFlock
//
//  Created by Guillermo Irigoyen on 10/21/18.
//  Copyright © 2018 Guillermo Irigoyen. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation


/// To classify types of data and omptimize for type of storage places
enum cachedDataType {
    case cities
    case flocks
    case schedules
    case all
    
    /// For clasification, logging and debugging
    var description : String {
        switch self {
            case .cities:    return "Cities"
            case .flocks:    return "Flocks"
            case .schedules: return "Schedules"
            case .all:       return "All"
        }
    }
    
}


/// Data Manager
/// - comment:   Centralized place to handle persistent an ephimeral data
///              Initialized by the Application Manager
final class DataManager {
    
    /// Application data containers
    private(set) var cities         : [String:City]     = [String:City]()       // City name : City
    private(set) var citiesIndex    : [String]          = [String]()            // Ordered by city name
    private(set) var flocks         : [String:Flock]    = [String:Flock]()      // Flock id  : Flock
    private(set) var flocksIndex    : [String]          = [String]()            // Ordered by Flock id
    private(set) var schedules      : [String:Schedule] = [String:Schedule]()   // DestinyCity_FlockId : [Schedule]
    private(set) var schedulesIndex : [String]          = [String]()            // Ordered by time
    
    /// "Cached data" containers, used mostly for map objects
    private(set) var citiesAnnotations  : [FlocksExplorerMapAnnotation] = [FlocksExplorerMapAnnotation]()
    private(set) var flocksAnnotations  : [FlocksExplorerMapAnnotation] = [FlocksExplorerMapAnnotation]()
    private(set) var scheduleAnnotations: [FlocksExplorerMapAnnotation] = [FlocksExplorerMapAnnotation]()
    
    /// Initializers
    init(){
        print("Initializing Data Manager ...")
        // We need at least one place to start - This could be with user location but for now is LA
        addNewCity(USERDEFAULTCITY)
        
    }
    
}


/// Cities
extension DataManager {
    
    /// Cities
    /// ADD
    public func addNewCity(_ aNewCity:City){
        if let cityName = aNewCity.name?.lowercased() {
            cities[cityName] = aNewCity
            print("NEW CITY: \(cityName.capitalized) city added ...")
            updateCityIndex()
            updateCacheFor(type: .cities)
        }
    }
    
    /// UPDATE
    /// Could be that city is named differently but is the same ex: Los Angeles - Angeles
    public func updateCity(_ anUpdatedCity:City){
        if let cityName = anUpdatedCity.name?.lowercased() {
            // TO-DO: Check for possible duplication of city
            if cities.keys.contains(cityName){
                cities[cityName] = anUpdatedCity
                print("UPDATED CITY: \(cityName.capitalized) city updated ...")
                updateCityIndex()
                updateCacheFor(type: .cities)
            } else {
                print("UPDATED CITY: \(cityName.capitalized) city not found, nothing to update ...")
            }
            
        }
    }
    
    /// Update city Index
    /// A city index can only be updated, depends on a city to exist
    private func updateCityIndex(){
        citiesIndex = Array(cities.keys).sorted { $0 < $1 }
    }

}


/// Flocks
extension DataManager {
    
    /// Flocks
    /// ADD
    public func addNewFlock(_ aNewFlock:Flock){
        if let flockId = aNewFlock.id {
            flocks[String(flockId)] = aNewFlock
            print("NEW FLOCK: New flock with Id: \(String(flockId)) added ...")
            updateFlocskIndex()
            updateCacheFor(type: .flocks)
        }
    }
    
    /// UPDATE
    public func updateFlock(_ anUpdatedFlock:Flock){
        if let flockId = anUpdatedFlock.id{
            let flockIdString = String(flockId)
            if flocks.keys.contains(flockIdString){
                flocks[flockIdString] = anUpdatedFlock
                print("UPDATED FLOCK: Flock with Id: \(String(flockId)) updated ...")
                updateFlocskIndex()
                updateCacheFor(type: .flocks)
            } else {
                print("UPDATED FLOCK: Flock with Id: \(String(flockId)) not found, nothing to update ...")
            }
        }
    }
    
    // Update flocks Index
    // A flock index can only be updated, depends on a flock to exist
    private func updateFlocskIndex(){
        flocksIndex = Array(flocks.keys).sorted { $0 < $1 }
    }
    
}


// Schedules Manipulation
extension DataManager {
    
    // Schedules
    // ADD
    // Steps:
    // If we have all the information needed Flock, Origin, Destination and valid time
    // Flock and City Checks:
    //  - Is Status Valid? .ready or .halted is OK NOTE: halted means is going to be redirected
    //  - Is Enough space in the city? current capacity is ok?
    //      Flock updates:
    //          + Add Schedule to Schedule History
    //          + Update status to .moving
    //      City updates:
    //          + Update Destination Capacity
    //          + Add Schedule to Origin Schedule History
    //      Schedule updates:
    //          + Update status to working
    //          + Add to Schedules
    //  - If Flock Status not Valid? .moving
    //  - If there is no Space in the city?
    //      Flock updates:
    //          + Add Schedule to Schedule History
    //      City updates:
    //          + Add Schedule to Schedule History
    //      Schedule updates:
    //          + Update status to .invalid
    //          + Add to Schedules
    //

    public func addNewSchedule(_ aNewSchedule:Schedule){
        
        var schedule    = aNewSchedule              as Schedule
        var flock       = flocks[String(aNewSchedule.flock.id)]
        var destination = cities[schedule.destinyCity.name]
        var origin      = cities[schedule.originCity.name]
        
        if schedule.scheduleId != nil {                     // DESTINYCITY_FLOCKID
            
            // Check if Flock is available
            if flock?.status == .ready ||
                flock?.status == .halted {
                
                // Reserve Capacity
                if (destination?.reserveCapacity(capacity: schedule.flock.count))! {
                    
                    print("NEW SCHEDULE: < OK > EVERYTHING IN ORDER  ...")
                    // If everything is correct
                    // Update status
                    flock?.updateStatus(status: .moving)
                    schedule.updateStatus(status: .working)
                    // Add Schedules to items
                    flock?.addSchedule(schedule: schedule)
                    origin?.addSchedule(schedule: schedule)
                    print("\n")
                    
                } else {
                    print("NEW SCHEDULE: < ERROR > NOT ENOUGH CAPACITY IN DESTINATION ...")
                    // If capacity is not met
                    flock?.updateStatus(status: .halted)
                    schedule.updateStatus(status: .invalid)
                    // Add Failed Status to item
                    flock?.addSchedule(schedule: schedule)
                    origin?.addSchedule(schedule: schedule)
                    let recorevered = (destination?.recoverCapacity(capacity: schedule.flock.count))! ? "OK" : "ERROR"
                    print("NEW SCHEDULE: < \(recorevered) > RECOVERING SPACE  ...")
                    print("\n")
                    
                }
                
            } else {
                print("NEW SCHEDULE < ERROR > SELECTED FLOCK IS NOT AVAILABLE ...")
                // If Flock is not available
                schedule.updateStatus(status: .invalid)
                print("\n")
                
            }
            
            // Create if new Schedule
            if schedules[schedule.scheduleId] != nil {
                print("NEW SCHEDULE: Schedule already exist ...")
                updateSchedule(schedule)
                
            // Update Schedule if exist
            } else {
                schedules[schedule.scheduleId] = schedule
                print("NEW SCHEDULE: New schedule created ...")
                
            }
            
            // Update cities
            updateCity(origin!)      // Updated Schedules
            updateCity(destination!) // Updated Capacity
            // Update flock
            updateFlock(flock!)      // Updated Schedules
            // Update schedules
            updateScheduleIndex()
            updateCacheFor(type: .schedules)
            
        }
    }
    
    // UPDATE
    public func updateSchedule(_ anUpdatedSchedule:Schedule){
        if let stringScheduleId = anUpdatedSchedule.scheduleId { // DESTINYCITY_FLOCKID
            if schedules.keys.contains(stringScheduleId){
                schedules[stringScheduleId] = anUpdatedSchedule
                print("UPDATED SCHEDULE: Schedule updated ...")
                updateScheduleIndex()
                updateCacheFor(type: .schedules)
            }
            print("UPDATED SCHEDULE: Schedule not found, nothing to update ...")
        }
    }
    
    // CANCEL
    public func cancelSchedule(_ aSchedule:Schedule){
        
        var schedule    = aSchedule as Schedule
        var flock       = flocks[String(aSchedule.flock.id)]
        var destination = cities[schedule.destinyCity.name]
        var origin      = cities[schedule.originCity.name]
        
        print("CANCEL SCHEDULE: READY TO CANCEL  ...")
        // If everything is correct
        // Update status
        flock?.updateStatus(status: .halted)
        schedule.updateStatus(status: .canceled)
        // Add Schedules to items
        flock?.addSchedule(schedule: schedule)
        origin?.addSchedule(schedule: schedule)
        let recorevered = (destination?.recoverCapacity(capacity: schedule.flock.count))! ? "OK" : "ERROR"
        print("CANCEL SCHEDULE: < \(recorevered) > CANCEL COMPLETE  ...")
        print("\n")
        
        // Update cities
        updateCity(origin!)      // Updated Schedules
        updateCity(destination!) // Updated Capacity
        // Update flock
        updateFlock(flock!)      // Updated Schedules
        // Update schedules
        updateSchedule(schedule)
        updateScheduleIndex()
        updateCacheFor(type: .schedules)
        
    }
    
    // Update Schedule Index
    // A Schedule index can only be updated, depends on a Schedule to exist
    // TO-DO: This will sort by key (name_id) not by schedule Id, needs to be updated
    private func updateScheduleIndex(){
        schedulesIndex = Array(schedules.keys).sorted { $0 < $1 }
    }
    
}


// Cache manipulation
extension DataManager {
    
    
    // UPDATE
    private func updateCacheFor(type aType:cachedDataType = .all){
        //TO-DO: Use actual caches and optimize loops
        switch aType {
            // All
            case .all:
                updateCacheFor(type: .cities)
                updateCacheFor(type: .flocks)
                updateCacheFor(type: .schedules)
                print("\(aType.description) data cache updated ...")
            // Cities
            case .cities:
                citiesAnnotations.removeAll()
                for city in cities.values {
                    let cityAnnotation = FlocksExplorerMapAnnotation(data: city, type: .city)
                    citiesAnnotations.append(cityAnnotation)
                    
                }
                print("\(aType.description) data cache updated ...")
            // Flocks
            case .flocks:
                flocksAnnotations.removeAll()
                for flock in flocks.values {
                    let flockAnnotation = FlocksExplorerMapAnnotation(data: flock, type: .flock)
                    flockAnnotation.coordinate = generateDistributedCoordinateFor(coordinate: flockAnnotation.coordinate)
                    flocksAnnotations.append(flockAnnotation)
                }
                print("\(aType.description) data cache updated ...")
            // Schedules
            case .schedules:
                scheduleAnnotations.removeAll()
                for schedule in schedules.values {
                    let scheduleAnnotation = FlocksExplorerMapAnnotation(data: schedule, type: .schedule)
                    scheduleAnnotation.coordinate = generateDistributedCoordinateFor(coordinate: scheduleAnnotation.coordinate)
                    scheduleAnnotations.append(scheduleAnnotation)
                }
                print("\(aType.description) data cache updated ...")
        }
    }
    
    // create random locations to declutter map
    func generateDistributedCoordinateFor(coordinate: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        
        func getBase(number: Double) -> Double {
            return round(number * 1000)/1000
        }
        func randomCoordinate() -> Double {
            return Double(arc4random_uniform(140)) * 0.015
        }
        
        let baseLatitude = getBase(number: coordinate.latitude)
        let baseLongitude = getBase(number: coordinate.longitude)
        let randomLat = baseLatitude + randomCoordinate()
        let randomLong = baseLongitude + randomCoordinate()
        let newCoordinate = CLLocationCoordinate2D(latitude: randomLat, longitude: randomLong)
        
        return newCoordinate
    }
}


// Example data
extension DataManager {
    
    public func askToLoadExampleData(){
        // convenience way to load example data if wanted
        let loadExampleDataAlert = UIAlertController(title: "NO DATA",
                                                     message: "Would you like to load some example data?, WARNING: The example data implements some BETA features outside of the scope of the delivery and.",
                                                   preferredStyle: .alert)
        // Load example data
        loadExampleDataAlert.addAction(UIAlertAction(title: "Load example data", style: .default , handler:{ UIAlertAction in
            self.setupExampleData()
        }))
        
        // Clean start
        loadExampleDataAlert.addAction(UIAlertAction(title: "No thanks", style: .cancel, handler:{ UIAlertAction in }))
        
        // Present alert in view
        VIEWCOORDINATOR.showAlert(alert: loadExampleDataAlert)
    }
    
    // Convenience function to fill app with dummy data
    private func setupExampleData() {
        print("\n\nLoading Example Data ... \n")
        print("Creating Example Cities ... \n")
        
        // Cities
        let city1 = City(name: "Austin",      latitude: 30.305804, longitude: -97.728682, capacity: 900)
        let city2 = City(name: "New York",    latitude: 40.7128,   longitude: -74.0060,   capacity: 300)
        
        addNewCity(city1)
        addNewCity(city2)
        
        print("\n\nCreating Example Flocks ... \n")
        
        /// Flocks
        let flock1 = Flock(id: 1, count: 200)   // Origin "LA"
        let flock2 = Flock(id: 2, count: 350)   // Origin "LA"
        var flock3 = Flock(id: 3, count: 50)
        flock3.setOriginCity(toCity: city1)     // Origin "AUSTIN" // Fixed for example
        var flock4 = Flock(id: 4, count: 200)
        flock4.setOriginCity(toCity: city2)     // Origin "NY"     // Fixed for example
        
        addNewFlock(flock1)
        addNewFlock(flock2)
        addNewFlock(flock3)
        addNewFlock(flock4)
        
        // Schedules hardcoded in ISO format
        print("\n\nCreating Example Schedules ... \n")
        let d1 = "2018-08-31T00:44:40+00:00"
        let d2 = "2018-09-24T00:44:40+00:00"
        let d3 = "2018-09-25T00:00:00+00:00"
        let d4 = "2018-10-18T12:00:00+00:00"
        let d5 = "2018-09-26T00:00:00+00:00"
        let d6 = "2018-09-30T12:00:00+00:00"
        let d7 = "2018-10-20T12:00:00+00:00"
        let d8 = "2018-12-17T12:00:00+00:00"

        // LA to Austin (0 of 900)                  200 birds --> Correct
        let schedule1 = Schedule(forFlock: flock1, toCity: city1, fromStartingDate: d1, toEndingDate: d2)

        // LA to NY (0 of 300)                      350 birds --> Invalid
        let schedule2 = Schedule(forFlock: flock2, toCity: city2, fromStartingDate: d3, toEndingDate: d4)
        // schedule2 should be invalidated
        // flock2    should be halted

        // LA to Austin (700 of 900)                350 birds --> Correct
        let schedule3 = Schedule(forFlock: flock2, toCity: city1, fromStartingDate: d3, toEndingDate: d4)
        // flock2 was first assinged to schedule 2 so if is available update

        // Austin (350 of 900) to NY (0 of 300)     50 birds --> Correct
        var schedule4 = Schedule(forFlock: flock3, toCity: city2, fromStartingDate: d5, toEndingDate: d6)
        schedule4.updateOriginCity(toCity: city1)   // Fixed for example

        // NY (250 of 300) to LA                    200 birds --> Correct
        var schedule5 = Schedule(forFlock: flock4, toCity: USERDEFAULTCITY, fromStartingDate: d7, toEndingDate: d8)
        schedule5.updateOriginCity(toCity: city2)   // Fixed for example
        // LA is unlimited so capacity and capacity taken should stay the same

        // Check if schedule is valid
        // - Is the Flock available (not used for any other schedule)?
        // - Do we have space in the destiny city?
        // - The time is correct?
        addNewSchedule(schedule1)
        addNewSchedule(schedule2)
        addNewSchedule(schedule3)
        addNewSchedule(schedule4)
        addNewSchedule(schedule5)
        print("\nExample Data Loaded ... \n")
        
    }
    
}


