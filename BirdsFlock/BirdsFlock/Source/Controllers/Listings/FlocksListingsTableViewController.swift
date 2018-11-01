//
//  FlocksListingsViewController.swift
//  BirdsFlock
//
//  Created by Guillermo Irigoyen on 10/24/18.
//  Copyright © 2018 Guillermo Irigoyen. All rights reserved.
//

import Foundation
import UIKit


class FlocksListingsTableViewController : UITableViewController {
    
    // Outlets
    @IBOutlet var listingTable: UITableView!
    
    // Properties
    var listingType           : FlockMapAnnotationType!
    var listingIndex          : [String]          = [String]()     // String keys ordered
    var listingData           : [String:Any]      = [String:Any]() // Hashed dictionary
    var listingSchedulesIndex : [String]          = [String]()
    var listingSchedules      : [String:Schedule] = [String:Schedule]()
    
    // Initializers
    convenience init(nibName nibNameOrNil: String?,
                     type aListingType:FlockMapAnnotationType,
                     bundle nibBundleOrNil: Bundle?) {
        self.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        listingType = aListingType
        
    }
    
    // Overrides
    override func viewDidLoad() {
        loadListingData(forType: listingType)
        tableView = listingTable
        // No Info cell
        tableView.register(UINib(nibName: "FlocksListingsNoScheduleTableViewCell", bundle: .main),
                           forCellReuseIdentifier: "NO_SCHEDULE_CELL_IDENTIFIER")
        // Schedule cell
        tableView.register(UINib(nibName: "FlocksListingsScheduleTableViewCell", bundle: .main),
                           forCellReuseIdentifier: "SCHEDULE_CELL_IDENTIFIER")
        
    }
    
    // Overrides
    override func viewDidAppear(_ animated: Bool) {
        loadListingData(forType: listingType)
        tableView.reloadData()
        
    }

    // ListingIndex is an oreded list of the keys
    func loadListingData(forType: FlockMapAnnotationType){
        
        listingSchedulesIndex = DATAMANAGER.schedulesIndex  // [ <DestinationCityName_FlockId> ] --> Ordered
        listingSchedules      = DATAMANAGER.schedules       // [ <DestinationCityName_FlockId> : <Schedule> ]
        
        switch forType {
        case .city:
            listingIndex = DATAMANAGER.citiesIndex  // [ <CityName> ] --> Ordered
            listingData  = DATAMANAGER.cities       as [String:City] // [ <CityName> : <City> ]
            
        case .flock:
            listingIndex = DATAMANAGER.flocksIndex  // [ <String_Flock_Id> ] --> Ordered
            listingData  = DATAMANAGER.flocks       as [String:Flock]// [ <String_Flock_Id> : <Flock> ]
            
        case .schedule:
            listingIndex = listingSchedulesIndex
            listingData  = listingSchedules
            break
            
        }
    }
}


extension FlocksListingsTableViewController {
    
    // Sections
    override public func numberOfSections(in tableView: UITableView) -> Int {
        
        // In case there is no data to show, create an informative section
        let defaultSectionsCount = 1
        
        switch listingType {
        case .some(.city):
            return listingData.keys.count > 0 ? listingData.keys.count : defaultSectionsCount
            
        case .some(.flock):
            return listingData.keys.count > 0 ? listingData.keys.count : defaultSectionsCount
            
        case .some(.schedule):
            return listingSchedules.count > 0 ? listingData.keys.count : defaultSectionsCount
            
        default:
            // This should never be reached because we always have a type
            return defaultSectionsCount
            
        }
    }
    
    // Headers
    override public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        // In case there is no data to show, create an informative title
        let defaultHeaderText = "No Data for \(String(listingType.string))."
        if listingIndex.indices.contains(section) || listingSchedulesIndex.indices.contains(section) {
        
            switch listingType {
            case .some(.city):
                //  listingData [ <CityName> : <City> ]
                let city = listingData[listingIndex[section]] as! City
                return city.name
                
            case .some(.flock):
                //  listingData [ <String_Flock_Id> : <Flock> ]
                let flock = listingData[listingIndex[section]] as! Flock
                return "Flock id: \(String(flock.id)) Size: \(String(flock.count))"
                
            case .some(.schedule):
                // scheduleData [ <DestinationCityName_FlockId> : <Schedule> ]
                let schedule = listingSchedules[listingSchedulesIndex[section]]
                return schedule?.originCity.name
                
            default:
                // This should never be reached because we always have a type
                return "Nothing Assigned"
            }
            
        } else { return defaultHeaderText }
        
    }
    
    // Footers
    override public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String?{
        
        // In case there is no data to show, create an informative title
        let defaultFooterText = "Nothing Assigned"
        if listingIndex.indices.contains(section) || listingSchedulesIndex.indices.contains(section) {
        
            switch listingType {
            case .some(.city):
                //  listingData [ <CityName> : <City> ]
                let city     = listingData[listingIndex[section]] as! City
                let capacity = city.capacity == 0 ? "UNLIMITED" : String(city.capacity)
                let left     = capacity == "UNLIMITED" ? capacity : String(Int(city.capacity)-(city.capacityTaken))
                return "Current capacity \(left) of \(capacity)"
                
            case .some(.flock):
                //  listingData [ <String_Flock_Id> : <Flock> ]
                let flock    = listingData[listingIndex[section]] as! Flock
                return "Status: \(flock.status!.description)"
                
            case .some(.schedule):
                // scheduleData [ <DestinationCityName_FlockId> : <Schedule> ]
                let schedule = listingSchedules[listingSchedulesIndex[section]]!
                return "Status: \(schedule.status.description)"
                
            default:
                // This should never be reached because we always have a type
                return defaultFooterText
            }
            
        } else {  return defaultFooterText }
        
    }
   
    // Rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // In case there is no data to show, create an informative cell
        let defaultRowsCount = 1
        if listingIndex.indices.contains(section) || listingSchedulesIndex.indices.contains(section) {
        
            switch listingType {
            case .some(.city):
                //  listingData [ <CityName> : <City> ]
                let cities = listingData as! [String:City]
                return (cities[listingIndex[section]]?.schedules.count)! > 0 ? (cities[listingIndex[section]]?.schedules.count)! : defaultRowsCount
                
            case .some(.flock):
                //  listingData [ <String_Flock_Id> : <Flock> ]
                let flocks = listingData as! [String:Flock]
                return (flocks[listingIndex[section]]?.schedules.count)! > 0 ? (flocks[listingIndex[section]]?.schedules.count)! : defaultRowsCount
                
            case .some(.schedule):
                // scheduleData [ <DestinationCityName_FlockId> : <Schedule> ]
                return defaultRowsCount
                
            default:
                // This should never be reached because we always have a type
                return defaultRowsCount
            }
            
        } else { return defaultRowsCount }
        
    }
    
    // Cells at Row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let noInfoCell   = tableView.dequeueReusableCell(withIdentifier: "NO_SCHEDULE_CELL_IDENTIFIER")
        let scheduleCell = tableView.dequeueReusableCell(withIdentifier: "SCHEDULE_CELL_IDENTIFIER") as! FlocksListingsScheduleTableViewCell
        
        var schedule : Schedule!
        if listingIndex.indices.contains(indexPath.section) && listingSchedulesIndex.indices.contains(indexPath.section) {
        
            switch listingType {
            case .some(.city):
                //  listingData [ <CityName> : <City> ]
                let cityName     = listingIndex[indexPath.section]
                let city         = listingData[cityName] as! City
                if city.schedules.indices.contains(indexPath.item){
                    let scheduleId   = city.schedules[indexPath.item]
                    schedule         = listingSchedules[scheduleId]
                }
                break
                
            case .some(.flock):
                //  listingData [ <String_Flock_Id> : <Flock> ]
                let flockName    = listingIndex[indexPath.section]
                let flock        = listingData[flockName] as! Flock
                let scheduleId   = flock.schedules[indexPath.item]
                schedule         = listingSchedules[scheduleId]
                break
                
            case .some(.schedule):
                // scheduleData [ <DestinationCityName_FlockId> : <Schedule> ]
                let scheduleName = listingSchedulesIndex[indexPath.section]
                schedule         = listingSchedules[scheduleName]
                break
                
            default:
                break
                
            }
            
            if schedule == nil { return noInfoCell! }
            
            scheduleCell.flockId.text     = String(schedule.flock.id)
            scheduleCell.flockCount.text  = String(schedule.flock.count)
            scheduleCell.scheduleStatus.text = schedule.status.description.uppercased()
            scheduleCell.backgroundColor  = (schedule.status.description == "invalid" ||
                schedule.status.description == "canceled" ) ? .red : .white
            scheduleCell.destinyCity.text = schedule.destinyCity.name.uppercased()
            scheduleCell.startDate.text   = ISO8601DateFormatter().string(from: schedule.startDate)
            scheduleCell.endDate.text     = ISO8601DateFormatter().string(from: schedule.endDate)
            
            return scheduleCell
            
        } else { return noInfoCell! }
        
    }
    
    // Selected Row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Detail
        var detailView : FlocksListingsDetailViewController
        detailView     = FlocksListingsDetailViewController(nibName: "FlocksListingsDetailViewController",
                                                        bundle: .main)
        detailView.detailMode = .edit
        // Only Schedules because listings are only showing schedules
        detailView.detailType = .schedule
        
        if listingIndex.indices.contains(indexPath.section) && listingSchedulesIndex.indices.contains(indexPath.section) {
        
            switch listingType {
            case .some(.city):
    //          // In case we want to edit or modify a city instead of a schedule
    //            detailView.detailType = .city
    //            let cityName = listingIndex[indexPath.section]
    //            detailView.dataObject = listingsData[cityName] as! City
                let cityName     = listingIndex[indexPath.section]
                let city         = listingData[cityName] as! City
                let scheduleId   = city.schedules[indexPath.item]
                detailView.dataObject = listingSchedules[scheduleId]
                break
                
            case .some(.flock):
    //          // In case we want to edit or modify a flock instead of a schedule
    //            detailView.detailType = .flock
    //            let flockName = listingIndex[indexPath.section]
    //            detailView.dataObject = listingsData[flockName] as! Flock
                let flockName    = listingIndex[indexPath.section]
                let flock        = listingData[flockName] as! Flock
                let scheduleId   = flock.schedules[indexPath.item]
                detailView.dataObject = listingSchedules[scheduleId]
                break
                
            case .some(.schedule):
                let scheduleName = listingSchedulesIndex[indexPath.section]
                detailView.dataObject = listingSchedules[scheduleName]
                break
            default:
                break
            }
            
            VIEWCOORDINATOR.pushViewController(detailView)
            
        }
        
    }
    
    // Custom cell height
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
}



