//
//  FlocksExplorerMapAnnotationView.swift
//  BirdsFlock
//
//  Created by Guillermo Irigoyen on 10/22/18.
//  Copyright © 2018 Guillermo Irigoyen. All rights reserved.
//

import Foundation
import MapKit

// Type of annotations
enum FlockMapAnnotationType {
    case city
    case flock
    case schedule
    
    // type as strings for convenience
    var string : String {
        switch self {
        case .city:     return "city"
        case .flock:    return "flock"
        case .schedule: return "schedule"
        }
    }
    
    // convenience identifier strings for reusable annotation views of type
    var annotationIdentifier : String {
        switch self {
            case .city:     return "CITIES_ANNOTATION_CUSTOMVIEW"
            case .flock:    return "FLOCKS_ANNOTATION_CUSTOMVIEW"
            case .schedule: return "SCHEDULE_ANNOTATION_CUSTOMVIEW"
        }
    }
    
    // for debug
    var description : String {
        switch self {
        case .city:     return "City annotation"
        case .flock:    return "Flock annotation"
        case .schedule: return "Schedule annotation"
        }
    }
    
}


// Custom annotaion views for map
class FlocksExplorerMapAnnotationView : MKAnnotationView {
    
    // Properties
    weak var customAnnotationView : UIView?
    var customAnnotationViewType  : FlockMapAnnotationType?
    // Override properties
    override var annotation       : MKAnnotation? {
        willSet{ customAnnotationView?.removeFromSuperview() }
    }
    
    // Initializers
    // - comment: This implementation uses Nib files in order to keep things DRY
    //            the convenience initializer includes the type of annotation
    convenience init(annotation: MKAnnotation?, type: FlockMapAnnotationType, reuseIdentifier: String?) {
        self.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        // Annotation view
        customAnnotationViewType = type
        // Annotation pin
        image = loadCustomPin(forType: type)
        
    }
    
}



// MARK: - Map Annotation overrides
extension FlocksExplorerMapAnnotationView {
    
    // To present the custom details view
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            // If custom pin is selected
            customAnnotationView?.removeFromSuperview()
            if let customView = loadCustomDetailView(forType: customAnnotationViewType!) {
                customView.frame.origin.x -= (customView.frame.width/2.0) - (frame.width/2.0)
                customView.frame.origin.y -= (customView.frame.height/2.0) - (frame.height/2.0)
                addSubview(customView)
                customAnnotationView = customView
                
                // Animate in
                if customAnnotationView != nil {
                    if animated {
                        showDetailAnimation(detailView: customAnnotationView)
                    }
                }
                
                print("Displaying \(String(describing: customAnnotationViewType!.description)) detail")
            }
            
        } else {
            // Animate out
            if customAnnotationView != nil {
                if animated {
                    hideDetailAnimation(detailView: customAnnotationView)
                }
                
            } else { customAnnotationView!.removeFromSuperview() }
            
        }
        
    }
    
    
    // To handle and distiguish betwwen Detail View touch and the Info Button inside the Detail View
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // If the touch is in the Map, or outside the Custom Anotation View
        if let parentHitView = super.hitTest(point, with: event) { return parentHitView }
        else {
            if customAnnotationView != nil {
                // If the annotaion is there, convert the coordinates to annotation view reference
                return customAnnotationView!.hitTest(convert(point, to: customAnnotationView!), with: event)
            } else { return nil }
        }
    }
    
    // prepare map for reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        customAnnotationView?.removeFromSuperview()
    }
    
}


// MARK: - Utilities
extension FlocksExplorerMapAnnotationView {
    
    // Custom Annotation pin image
    func loadCustomPin(forType:FlockMapAnnotationType) -> UIImage {
        switch forType {
        case .city:
            return UIImage(named: "citiesAnnotation")!
        case .flock:
            return UIImage(named: "flocksAnnotation")!
        case .schedule:
            return UIImage(named: "scheduleAnnotation")!
        }
    }
    
    // Load Custom Detail View depending on the type
    func loadCustomDetailView(forType:FlockMapAnnotationType) -> UIView? {
        var view           : UIView?
        
        switch forType {
            case .city:
                view = loadViewFromNib(nibName: "FlocksExplorerMapCityAnnotationView")
                let viewType       = view as! FlocksExplorerMapCityAnnotationView
                let viewAnnotation = annotation as! FlocksExplorerMapAnnotation
                let viewData       = viewAnnotation.mappableObject as! City
                viewType.fillAnnotationWithCity(viewData)
                
                return viewType
            
            case .flock:
                view = loadViewFromNib(nibName: "FlocksExplorerMapFlockAnnotationView")
                let viewType       = view as! FlocksExplorerMapFlockAnnotationView
                let viewAnnotation = annotation as! FlocksExplorerMapAnnotation
                let viewData       = viewAnnotation.mappableObject as! Flock
                viewType.fillAnnotationWithFlock(viewData)
                
                return viewType
            
            case .schedule:
                view = loadViewFromNib(nibName: "FlocksExplorerMapScheduleAnnotationView")
                let viewType       = view as! FlocksExplorerMapScheduleAnnotationView
                let viewAnnotation = annotation as! FlocksExplorerMapAnnotation
                let viewData       = viewAnnotation.mappableObject as! Schedule
                viewType.fillAnnotationWithSchedule(viewData)
                
                return viewType
        }
    }
    

}



// Animations
extension FlocksExplorerMapAnnotationView {
    
    // Show detail
    func showDetailAnimation(detailView:UIView?) {
        // TO-DO: find a best way to find the map view
        let mapView = (superview?.superview?.superview as? FlocksExplorerMapView)
        // TO-DO: find a best way to set the coordinate
        let annotationCoordinate = CLLocationCoordinate2D(latitude: ((annotation?.coordinate.latitude)!-15),
                                                          longitude: ((annotation?.coordinate.longitude)!))
        if let detail = detailView {
            detail.alpha = 0.0
            UIView.animate(withDuration: 0.5, animations: {
                if mapView != nil {
                    let viewRegion = MKCoordinateRegion(center: annotationCoordinate,
                                                        latitudinalMeters: 5000000,
                                                        longitudinalMeters: 5000000)
                    mapView?.setRegion(viewRegion, animated: true)
                }
                detail.alpha = 1.0
            })
        }
    }
    
    // Hide detail
    func hideDetailAnimation(detailView:UIView?){
        if let detail = detailView {
            UIView.animate(withDuration: 0.1, animations: {
                detail.alpha = 0.0
            }, completion: { success in
                detail.removeFromSuperview()
            })
        }
    }
    
    // Center Map
    // TO-DO: This is animation is on the map AND MUST be optimized
    private func centerMap(){
        // TO-DO: find a best way to find the map view
        let mapView = (superview?.superview?.superview as? FlocksExplorerMapView)
        mapView?.centerMap()
    }
    
    
}
