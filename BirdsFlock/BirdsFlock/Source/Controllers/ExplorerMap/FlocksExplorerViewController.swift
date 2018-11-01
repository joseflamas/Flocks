//
//  FlocksExplorerViewController.swift
//  BirdsFlock
//
//  Created by Guillermo Irigoyen on 10/21/18.
//  Copyright © 2018 Guillermo Irigoyen. All rights reserved.
//

import Foundation
import UIKit
import MapKit


/// Flocks Explorer View
//
//  Main View of the application, contains a map with all interesting points
//  withe resumed data and way to add, edit or remove Cities, Flocks and Schedules Listings and details
final class FlocksExplorerViewController : UIViewController {
    
    // IBOutlets
    @IBOutlet weak var flocksMap                      : FlocksExplorerMapView!
    @IBOutlet weak var flocksMapToolbar               : UIToolbar!
    @IBOutlet weak var flocksMapToolbarCitiesButton   : UIBarButtonItem!
    @IBOutlet weak var flocksMapToolbarFlocksButton   : UIBarButtonItem!
    @IBOutlet weak var flocksMapToolbarScheduleButton : UIBarButtonItem!
    
    //  Map Properties
    var currentAnnotationType : FlockMapAnnotationType!
    var flockMapAnnotations   : [FlocksExplorerMapAnnotation] = [FlocksExplorerMapAnnotation]()
    
    // Initializers
    // - comment: This implementation uses Nib files so no need to override view controller init
    //            unless there is a reason

    // Controller overrides
    override func viewDidLoad() {
        setupMapView()
        setupButtonActions()
    }
    
    // To reload after detail update
    override func viewWillAppear(_ animated: Bool) {
        checkfirstLaunch()
        setFlockMapAnnotations(forType:currentAnnotationType)
    }
    
    // Map setup
    private func setupMapView(){
        // Map
        flocksMap.delegate = self
        // Annotations
        currentAnnotationType = .city
    }
    
    // Button setup
    private func setupButtonActions(){
        // Buttons
        // - comment: because selector limitations need to use a hint to keep methods dry
        flocksMapToolbarCitiesButton.accessibilityHint   = "showCities"
        flocksMapToolbarCitiesButton.action   = #selector(showAnnotationDetailforType(_:))
        flocksMapToolbarFlocksButton.accessibilityHint   = "showFlocks"
        flocksMapToolbarFlocksButton.action   = #selector(showAnnotationDetailforType(_:))
        flocksMapToolbarScheduleButton.accessibilityHint = "showSchedules"
        flocksMapToolbarScheduleButton.action = #selector(showAnnotationDetailforType(_:))
    }
    
}


// MARK: - Map Delegate Methods
extension FlocksExplorerViewController : MKMapViewDelegate {
    
    // Map Annotations
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        // Ignore user Annotation
        // TO-DO: Maybe later use user location to enhance experience
        if annotation is MKUserLocation { return nil }
        
        var annotationView: MKAnnotationView?
        annotationView = flocksMap.dequeueReusableAnnotationView(withIdentifier: currentAnnotationType.annotationIdentifier)
        annotationView = FlocksExplorerMapAnnotationView(annotation: annotation,
                                                         type: currentAnnotationType,
                                                         reuseIdentifier: currentAnnotationType.annotationIdentifier)
        
        return annotationView
    }
    
    // Map Data Utilities
    func setFlockMapAnnotations(forType:FlockMapAnnotationType){
        // Remove current annotations
        flocksMap.removeAnnotations(flocksMap.annotations)
        
        // Add new ones based on the type
        switch forType {
        case .city:
            flocksMap.addAnnotations(DATAMANAGER.citiesAnnotations)
        case .flock:
            flocksMap.addAnnotations(DATAMANAGER.flocksAnnotations)
        case .schedule:
            flocksMap.addAnnotations(DATAMANAGER.scheduleAnnotations)
        }
        
    }
    
}

// MARK: - Tool Bar Menu
extension FlocksExplorerViewController {

    // This could have been a FlockMapAnnotationType but Objc does not support complex swift enum types
    // - comment: Objc limitation
    @objc
    func showAnnotationDetailforType(_ sender: Any){
        let button = sender as! UIBarButtonItem
        var type : FlockMapAnnotationType
        switch button.accessibilityHint {
            case "showCities":
                type = .city
            case "showFlocks":
                type = .flock
            case "showSchedules":
                type = .schedule
            default:
                type = .city
                break
        }
        showDetail(aType: type)
    }
    
    // Set current annotations
    func showDetail(aType: FlockMapAnnotationType){
        // Center the map
        self.flocksMap.centerMap()
        // Continue with the options menu
        currentAnnotationType = aType
        setFlockMapAnnotations(forType: aType)
        showOptionsfor(annotationType: aType)
        
        print("\(aType.description.capitalized)s presented in map")
    }
    
    
    // Option menu to access listing and detail views
    func showOptionsfor(annotationType: FlockMapAnnotationType) {
        // Center map
        flocksMap.centerMap()
        // Using an action sheet at the moment
        // TO-DO: create custom menu
        let menu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        // Details
        let newObjectButtonTitle           = "Create New \(annotationType.string.capitalized)"
        // Listings
        let showListingsButtonTitle        = "Show Schedules by \(annotationType.string.capitalized)"
        
        // Create a new object
        menu.addAction(UIAlertAction(title: newObjectButtonTitle, style: .default , handler:{ UIAlertAction in
            // Detail view for new object
            let detailViewController = FlocksListingsDetailViewController(nibName: "FlocksListingsDetailViewController",
                                                                          bundle: .main,
                                                                          type: annotationType,
                                                                          mode: .new)
            
            VIEWCOORDINATOR.pushViewController(detailViewController)
            
        }))
        
        // Go to object listings
        menu.addAction(UIAlertAction(title: showListingsButtonTitle, style: .default , handler:{ UIAlertAction in
            // Listings view for object
            let listingsViewController = FlocksListingsTableViewController(nibName: "FlocksListingsTableViewController",
                                                                           type: annotationType,
                                                                           bundle: .main)
            
            VIEWCOORDINATOR.pushViewController(listingsViewController)
            
        }))
        
        // Close menu
        menu.addAction(UIAlertAction(title: "Close", style: .cancel, handler:{ UIAlertAction in }))
        // Present menu in view
        VIEWCOORDINATOR.presentViewController(menu)
        
    }
}

extension FlocksExplorerViewController {
    
    // Convinient way to load example data
    private func checkfirstLaunch(){
        if USERFIRSTLAUNCH {
            DATAMANAGER.askToLoadExampleData()
            USERFIRSTLAUNCH = false
        }
    }
    
}




