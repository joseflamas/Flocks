//
//  Strings.swift
//  BirdsFlock
//
//  Created by Guillermo Irigoyen on 10/21/18.
//  Copyright © 2018 Guillermo Irigoyen. All rights reserved.
//

import Foundation


///  Strings File 
///  - commnet: Centralized file with all the common messages and Key strings for
///              alerts, messages, labels, etc

/// MARK: - Version naming strings
let TEXT_APPLICATIONNAME   : String = "Flocks"
let TEXT_ALIVEMESSAGE      : String = "Where are we going?"
let TEXT_VERSIONCODENAME   : String = "Palila"
let TEXT_VERSIONNUMBER     : String = "0.1.1"


/// MARK: - Alert strings
/// No information found alert
let TEXT_NO_INFO_ALERT_TITLE    : String = "No stored data"
let TEXT_NO_INFO_ALERT_MESSAGE  : String = "Would you like an example?"
let TEXT_NO_INFO_ALERT_ACCEPT   : String = "Yes please"
let TEXT_NO_INFO_ALERT_DENY     : String = "No thanks"


/// MARK: - Error strings
/// No information errors
let TEXT_INFO_NOT_FOUND_ERROR_TITLE   : String = "Information not found"
let TEXT_INFO_NOT_FOUND_ERROR_MESSAGE : String = "The information is not there or don't exist"

/// City errors
let TEXT_CITY_ERROR_TITLE            : String = "City Error"
let TEXT_CITY_GENERIC_ERROR_MESSAGE  : String = "There was a problem with the city"
let TEXT_CITY_EXISTS_ERROR_MESSAGE   : String = "The city you are trying to create already exists."
let TEXT_CITY_WRONG_NAME_MESSAGE     : String = "The city needs a name, please enter valid one."
let TEXT_CITY_WRONG_LATITUD_MESSAGE  : String = "The latitud must be a valid numeric value like 34.048925"
let TEXT_CITY_WRONG_LONGITUD_MESSAGE : String = "The longitud must be a valid numeric value like 118.428663 or -118.428663"
let TEXT_CITY_WRONG_CAPACITY_MESSAGE : String = "There is not enough space in the city."

/// Flock errors
let TEXT_FLOCK_ERROR_TITLE           : String = "Flock Error"
let TEXT_FLOCK_GENERIC_ERROR_MESSAGE : String = "There was a problem with the flock."
let TEXT_FLOCK_INVALID_ID            : String = "The flock needs a valid numeric ID, please choose a valid one."
let TEXT_FLOCK_EXIST_ERROR_MESSAGE   : String = "The flock id already exists."
let TEXT_FLOCK_WRONG_COUNT           : String = "There must be at least two birds in the flock."

/// Schedule errors
let TEXT_SCHEDULE_ERROR_TITLE            : String = "Schedule Error"
let TEXT_SCHEDULE_GENERIC_ERROR_MESSAGE  : String = "There was a problem with the Schedule"
let TEXT_SCHEDULE_INVALID_DATES          : String = "Invalid Dates, the delivery date must be after the starting date."
let TEXT_SCHEDULE_DELIVER_NOT_POSIBLE    : String = "The flock can't be delivered on time, adjust the dates increasing the time period."
let TEXT_SCHEDULE_NEEDS_A_VALID_FLOCK    : String = "There is not a flock to move, please select one or create a new one."
let TEXT_SCHEDULE_FLOCK_ALREADY_ASSINGED : String = "The selected flock is not available at the moment, please select one or create a new one."
let TEXT_SCHEDULE_NEEDS_A_VALID_CITY     : String = "There is not a city to deliver, please select one or create a new one."
let TEXT_SCHEDULE_INVALID_DESTINATION    : String = "The destination can not be the origin, please select other or create a new one."
let TEXT_SCHEDULE_CITY_OVER_CAPACITY     : String = "The destination city does not have the capacity available to deliver, please select another or create one."

