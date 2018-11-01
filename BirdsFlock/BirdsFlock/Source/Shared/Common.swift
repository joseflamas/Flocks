//
//  Common.swift
//  BirdsFlock
//
//  Created by Guillermo Irigoyen on 10/21/18.
//  Copyright © 2018 Guillermo Irigoyen. All rights reserved.
//

import Foundation
import CoreLocation

/// MARK: - Main Components
// - commnet: Based in the Separation of Concerns (SoC) Principle

/// Application Manager
// - comment:   Controls all the interaction between the OS and the App
//              this includes, notifications, permitions, etc.
//              Only Singleton in the Application.
var APPMANAGER       :   AppManager!

/// View Coordinator
// - comment:   Acts as Views and Views Controllers Coordinator
//              Initialized by the Application Manager
var VIEWCOORDINATOR  :   ViewsCoordinator!

/// Data Manager
// - comment:   Centralized place to handle persistent an ephimeral data
//              Initialized by the Application Manager
var DATAMANAGER      :   DataManager!

/// TO-DO: Security Manager
// - comment:   Centralized place to handle all sensitive information
// User Location
let USERLATITUD     : Double = 34.0093     // LA by default (latitud: 34.0093, longitude: -118.4286)
let USERLONGITUD    : Double = -118.4286
let USERCOORDINATE  : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: USERLATITUD, longitude: USERLONGITUD)
let USERDEFAULTCITY : City   = City(name: "los angeles", latitude: Float(USERLATITUD), longitude: Float(USERLONGITUD))
// Convinient way to load example data
var USERFIRSTLAUNCH : Bool  = true
