//
//  FlocksListingsScheduleDetailsView.swift
//  BirdsFlock
//
//  Created by Guillermo Irigoyen on 10/29/18.
//  Copyright © 2018 Guillermo Irigoyen. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class FlocksListingsScheduleDetailsView : UIView {
    

    @IBOutlet weak var scheduleScrollView: UIScrollView!
    @IBOutlet weak var scheduleFlockIdLabel: UILabel!
    @IBOutlet weak var scheduleFlockPicker: UIPickerView!
    @IBOutlet weak var scheduleCityNameLabel: UILabel!
    @IBOutlet weak var scheduleCityPicker: UIPickerView!
    @IBOutlet weak var scheduleStartDateLabel: UILabel!
    @IBOutlet weak var scheduleStartDatePicker: UIDatePicker!
    @IBOutlet weak var scheduleEndDateLabel: UILabel!
    @IBOutlet weak var scheduleEndDatePicker: UIDatePicker!
    @IBOutlet weak var scheduleCancelButton: UIButton!
    @IBOutlet weak var scheduleSaveButton: UIButton!
    
    var schedule   : Schedule?
    var detailMode : DetailMode!
    var today      : Date!
    
    // Overrides// Overrides
    override func layoutSubviews() {
        setupViewFor(mode: detailMode)
        setupActions()
    }
    
    // Setup View
    private func setupViewFor(mode: DetailMode = .edit){
        
        switch mode {
        case .new:
            scheduleFlockIdLabel.isHidden   = true
            scheduleCityNameLabel.isHidden  = true
            scheduleStartDateLabel.isHidden = true
            scheduleEndDateLabel.isHidden   = true
            scheduleCancelButton.isHidden   = true
            scheduleStartDatePicker.minimumDate = today
            scheduleEndDatePicker.minimumDate   = today
            scheduleCancelButton.isHidden   = true
            break
            
        case .view, .edit:
            scheduleSaveButton.isHidden      = true
            if let s = schedule {
                scheduleFlockIdLabel.text    = String(s.flock.id)
                scheduleFlockPicker.isHidden = true
                scheduleCityNameLabel.text   = s.destinyCity.name
                scheduleCityPicker.isHidden  = true
                scheduleStartDateLabel.text  = ISO8601DateFormatter().string(from: s.startDate)
                scheduleStartDatePicker.date = s.startDate
                scheduleStartDatePicker.isEnabled = false
                scheduleEndDateLabel.text    = ISO8601DateFormatter().string(from: s.endDate)
                scheduleEndDatePicker.date   = s.endDate
                scheduleEndDatePicker.isEnabled = false
            }
            break
            
        }
        
    }
    
    // Setup ACtions
    private func setupActions(){
        // Tags for multiple pickers
        scheduleFlockPicker.tag      = 1
        scheduleCityPicker.tag       = 2
        scheduleStartDatePicker.tag  = 3
        scheduleEndDatePicker.tag    = 4
        scheduleFlockPicker.delegate = self
        scheduleCityPicker.delegate  = self
        today = Date()
        
        // Cancel
        scheduleCancelButton.addTarget(self, action: #selector(FlocksListingsScheduleDetailsView.cancelSchedule(sender:)), for: .touchUpInside)
        
        // Save
        scheduleSaveButton.addTarget(self, action: #selector(FlocksListingsScheduleDetailsView.saveSchedule(sender:)), for: .touchUpInside)
        
    }
    
    
    // Cancel schedule
    @objc
    func cancelSchedule(sender: UIButton!){
        print("Cancel Schedule")
        cancel(schedule: schedule!)
        
    }
    
    // Save city
    @objc
    func saveSchedule(sender: UIButton!){
        print("Save Schedule")
        save()
        
    }
    

}


// Pickers Data Source
extension FlocksListingsScheduleDetailsView : UIPickerViewDataSource {
    
    // Number of components
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Number of Rows
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch pickerView.tag {
        case 1:
            return DATAMANAGER.flocksIndex.count
            
        case 2:
            return DATAMANAGER.citiesIndex.count
            
        default:
            return 1
            
        }
    }
    
    // Title for Row
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch pickerView.tag {
        case 1:
            return String(DATAMANAGER.flocks[DATAMANAGER.flocksIndex[row]]!.id)
            
        case 2:
            return DATAMANAGER.cities[DATAMANAGER.citiesIndex[row]]!.name
            
        default:
            return ""
            
        }
        
    }
}


// Pickers Delegate
extension FlocksListingsScheduleDetailsView : UIPickerViewDelegate {
}

// Utilities
extension FlocksListingsScheduleDetailsView  {
    
    // Save
    private func save(){
        
        // Flocks
        // Check if exist
        if !DATAMANAGER.flocksIndex.indices.contains(scheduleFlockPicker.selectedRow(inComponent: 0)) {
            showAlert(withMessage: TEXT_SCHEDULE_NEEDS_A_VALID_FLOCK)
            return
        }
        let selectedFlockId   : String = String(DATAMANAGER.flocksIndex[scheduleFlockPicker.selectedRow(inComponent: 0)])
        let selectedFlock     : Flock? = DATAMANAGER.flocks[selectedFlockId]
        // Check ifis in a valid state
        if !(selectedFlock != nil && (selectedFlock?.status == .ready || selectedFlock?.status == .halted)){
            showAlert(withMessage: TEXT_SCHEDULE_FLOCK_ALREADY_ASSINGED)
            return
        }
        
        // Cities
        let originCity        : City?  = USERDEFAULTCITY
        // Check if the destination exists
        if !DATAMANAGER.citiesIndex.indices.contains(scheduleCityPicker.selectedRow(inComponent: 0)){
            showAlert(withMessage: TEXT_SCHEDULE_NEEDS_A_VALID_CITY)
            return
        }
        let selectedCityName  : String = String(DATAMANAGER.citiesIndex[scheduleCityPicker.selectedRow(inComponent: 0)])
        let selectedCity      : City?  = DATAMANAGER.cities[selectedCityName]
        // Check if the destination is not the same as the origin
        if (originCity?.name == selectedCity?.name) {
            showAlert(withMessage: TEXT_SCHEDULE_INVALID_DESTINATION)
            return
        }
        // Check if the city has the capacity
        if !(selectedCity != nil && selectedCity!.hasSpacefor(capacity: selectedFlock!.count)) {
            showAlert(withMessage: TEXT_SCHEDULE_CITY_OVER_CAPACITY)
            return
        }
        
        // Dates
        let selectedStartDate : Date?  = scheduleStartDatePicker.date
        let selectedEndDate   : Date?  = scheduleEndDatePicker.date
        // Check valid dates
        if !(selectedStartDate! < selectedEndDate!){
            showAlert(withMessage: TEXT_SCHEDULE_INVALID_DATES)
            return
        }
        // Check if the time frame is possible
        let sLocation = CLLocation(latitude: originCity!.latitude, longitude: originCity!.longitude)
        let eLocation = CLLocation(latitude: selectedCity!.latitude, longitude: selectedCity!.longitude)
        if !(enoughtime(sDate: selectedStartDate!, eDate: selectedEndDate!,
                        sPoint: sLocation, ePoint:eLocation)){
            showAlert(withMessage: TEXT_SCHEDULE_DELIVER_NOT_POSIBLE)
            return
        }
        
        let newSchedule : Schedule! = Schedule(forFlock: selectedFlock!,
                                               toCity: selectedCity!,
                                               fromStartingDate: ISO8601DateFormatter().string(from: selectedStartDate!),
                                               toEndingDate: ISO8601DateFormatter().string(from:selectedEndDate!))
        
        print("SCHEDULE: Adding new schedule ...")
        DATAMANAGER.addNewSchedule(newSchedule)
        VIEWCOORDINATOR.popViewController()
        
    }
    
    private func enoughtime(sDate:Date, eDate:Date, sPoint:CLLocation, ePoint:CLLocation) -> Bool {
        // meters
        let distance  = Float(ePoint.distance(from: sPoint))
        // speed in meters per second
        let velocity  = Float(((50 * 1000)/60)/60) // 50 kph in meters per second (((50 * 1000)/60)/60) ~ 14 mps
        // time limit in seconds
        let timeLimit = Float(eDate.timeIntervalSince(sDate)) // seconds
        
        let distanceinKm  = distance/1000
        let velocityinKmh = (velocity/1000)*60*60
        let timeinH       = ((distance / velocity)/3600)
        let timeLimitinH  = (timeLimit/3600)
        print("\n Approximate distance \(String(distance)) in meters or \(distanceinKm) km.")
        print("\n Approximate velocity \(String(velocity)) meters per second or \(velocityinKmh) kmh.")
        print("\n Approximate time Limit \(String(timeLimit)) seconds or \(timeLimitinH) h. \n")
        
        if timeinH < timeLimitinH {
            print("\n Approximate deliver time \(String(timeinH)) hours in \(String(timeLimitinH)) hours limit is correct. \n")
            return true
        }
        print("\n Approximate deliver time \(String(timeinH)) hours in \(String(timeLimitinH)) hours limit is not possible. \n")
        return false
        
    }
    
    // Error
    private func showAlert(withMessage aMessage: String){
        print("SCHEDULE ERROR: \(aMessage)")
        VIEWCOORDINATOR.showAlert(withTitle: TEXT_SCHEDULE_ERROR_TITLE, andMessage: aMessage)
        
    }
    
    // Update
    private func update(schedule: Schedule){
        print("SCHEDULE: Updating schedule")
        DATAMANAGER.updateSchedule(schedule)
        VIEWCOORDINATOR.popViewController()
    }
    
    // Cancel
    private func cancel(schedule: Schedule){
        print("SCHEDULE: Canceling schedule")
        DATAMANAGER.cancelSchedule(schedule)
        VIEWCOORDINATOR.popViewController()
    }
    
}

