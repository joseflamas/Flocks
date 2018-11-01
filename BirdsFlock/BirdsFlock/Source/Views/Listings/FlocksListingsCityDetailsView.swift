//
//  FlocksListingsCityDetailsView.swift
//  BirdsFlock
//
//  Created by Guillermo Irigoyen on 10/24/18.
//  Copyright © 2018 Guillermo Irigoyen. All rights reserved.
//

import Foundation
import UIKit



class FlocksListingsCityDetailsView : UIView {
    
    // Outlets

    @IBOutlet weak var cityScrollView: UIScrollView!
    @IBOutlet weak var cityNameTextInput: UITextField!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var cityCapacityTextInput: UITextField!
    @IBOutlet weak var cityCapacityLabel: UILabel!
    @IBOutlet weak var cityLatTextInput: UITextField!
    @IBOutlet weak var cityLatLabel: UILabel!
    @IBOutlet weak var cityLonTextInput: UITextField!
    
    @IBOutlet weak var cityLonLabel: UILabel!
    
    @IBOutlet weak var saveButton: UIButton!
 
    // Properties
    var city : City?
    var detailMode : DetailMode!
    
    // Overrides
    override func layoutSubviews() {
        setupViewFor(mode: detailMode)
        setupActions()
    }
    
    // Setup View
    private func setupViewFor(mode: DetailMode){
        cityScrollView.contentSize = CGSize(width: cityScrollView.frame.width, height: cityScrollView.frame.height * 1.5)
        switch mode {
        case .new:
            cityNameLabel.isHidden     = true
            cityCapacityLabel.isHidden = true
            cityCapacityTextInput.text = "0"
            cityLatLabel.isHidden      = true
            cityLonLabel.isHidden      = true
            break
            
        case .edit:
            if let c = city{
                cityNameLabel.text         = c.name
                cityCapacityLabel.text     = String(c.capacity)
                cityLatLabel.text          = String(c.latitude)
                cityLonLabel.text          = String(c.longitude)
                cityNameTextInput.text     = c.name
                cityCapacityTextInput.text = c.capacity == 0 ? "UNLIMITED" : String(c.capacity)
                cityLatTextInput.text      = String(c.latitude)
                cityLonTextInput.text      = String(c.longitude)
            }
            break
            
        case .view:
            cityNameTextInput.isHidden     = true
            cityCapacityTextInput.isHidden = true
            cityLatTextInput.isHidden      = true
            cityLonTextInput.isHidden      = true
            saveButton.isHidden            = true
            if let c = city{
                cityNameLabel.text         = c.name.uppercased()
                cityCapacityLabel.text     = c.capacity == 0 ? "UNLIMITED" : String(c.capacity)
                cityLatLabel.text          = String(c.latitude)
                cityLonLabel.text          = String(c.longitude)
            }
            break
            
        }
    }
    
    // Setup ACtions
    private func setupActions(){
        // Save City
        saveButton.addTarget(self,
                             action: #selector(FlocksListingsCityDetailsView.saveCity(sender:)),
                             for: .touchUpInside)
        
    }
    
    // Save city
    @objc
    func saveCity(sender: UIButton!){
        print("Save city")
        checkData()
        
    }
    
}

extension FlocksListingsCityDetailsView {
    
    // Checks
    private func checkData(){
        
        // Name
        // Check if user entered a name
        var aName = cityNameTextInput.text?.lowercased()
        if aName?.last == " " { aName?.removeLast() } // particular issue with smart keyboard
        if aName == nil || aName == " " || (aName?.count)! <= 1 {
            showAlert(withMessage: TEXT_CITY_WRONG_NAME_MESSAGE)
            return
        }
        
        // Check if the city already exists
        if DATAMANAGER.citiesIndex.contains(aName!) {
            showAlert(withMessage: TEXT_CITY_EXISTS_ERROR_MESSAGE)
            return
        }
        
        // Location
        // Check if user entered a lat and lon
        if (cityLatTextInput.text == nil || cityLatTextInput.text?.floatValue == nil) ||
            (cityLonTextInput.text == nil || cityLonTextInput.text?.floatValue == nil) {
            showAlert(withMessage: TEXT_CITY_WRONG_LATITUD_MESSAGE + " or " + TEXT_CITY_WRONG_LONGITUD_MESSAGE)
            return
        }
        // Check if is  valid float value for lat and lon
        let aLat = cityLatTextInput.text?.floatValue
        let aLon = cityLonTextInput.text?.floatValue
        
        // Capacity
        // If there is a fixed capacity
        let aCapacity = cityCapacityTextInput.text?.integerValue
        if aCapacity == nil {
            // With limited Capacitty
            let aCity = City(name: aName!, latitude: aLat!, longitude: aLon!)
            save(city: aCity)
            return
        }
        
        // Unlimited Capacity
        let aCity = City(name: aName!, latitude: aLat!, longitude: aLon!, capacity: aCapacity!)
        save(city: aCity)
        return
        
    }
    
    // Error
    private func showAlert(withMessage aMessage: String){
        print("ERROR: \(aMessage)")
        VIEWCOORDINATOR.showAlert(withTitle: TEXT_CITY_ERROR_TITLE, andMessage: aMessage)
        
    }
    
    // Save
    private func save(city: City){
        print("Saving new city")
        DATAMANAGER.addNewCity(city)
        VIEWCOORDINATOR.popViewController()
    }
    
}
