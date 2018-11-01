//
//  FlocksListingDetailViewController.swift
//  BirdsFlock
//
//  Created by Guillermo Irigoyen on 10/25/18.
//  Copyright © 2018 Guillermo Irigoyen. All rights reserved.
//

import Foundation
import UIKit

enum DetailMode {
    case new
    case view
    case edit
}

class FlocksListingsDetailViewController : UIViewController {
    
    // Outlets
    @IBOutlet weak var closeButton: UIButton!
    
    // Properties
    var detailType  : FlockMapAnnotationType!
    var detailMode  : DetailMode!
    var dataObject  : Any?
    
    // Initializers
    convenience init(nibName nibNameOrNil: String?,
                     bundle nibBundleOrNil: Bundle?,
                     type aListingType: FlockMapAnnotationType,
                     mode aDetailMode: DetailMode = .edit) {
        
        self.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        detailType = aListingType
        detailMode = aDetailMode
        
    }

    // Overrides
    override func viewDidLoad() {

        // Add detail
        let detailView = setupDetailViewFor(type: detailType, inMode: detailMode)
        view.addSubview(detailView!)
        
        // Add actions
        setupActions()
        
    }
    
    private func setupDetailViewFor(type: FlockMapAnnotationType, inMode: DetailMode) -> UIView! {
        
        var view : UIView!
        
        switch type {
        case .city:
            view = FlocksListingsCityDetailsView().loadViewFromNib(nibName: "FlocksListingsCityDetailsView")
            let cityView = view as! FlocksListingsCityDetailsView
            cityView.city = dataObject != nil ? dataObject as? City : nil
            cityView.detailMode = detailMode
            break
        
        case .flock:
            view = FlocksListingsFlockDetailsView().loadViewFromNib(nibName: "FlocksListingsFlockDetailsView")
            let flockView = view as! FlocksListingsFlockDetailsView
            flockView.flock = dataObject != nil ? dataObject as? Flock : nil
            flockView.detailMode = detailMode
            break
        
        case .schedule:
            view = FlocksListingsScheduleDetailsView().loadViewFromNib(nibName: "FlocksListingsScheduleDetailsView")
            let scheduleView = view as! FlocksListingsScheduleDetailsView
            scheduleView.schedule = dataObject != nil ? dataObject as? Schedule : nil
            scheduleView.detailMode = detailMode
            break
        }
        return view
        
    }
    
    
    private func setupActions(){
        // Close Button for detail
        closeButton.addTarget(self,
                              action: #selector(FlocksListingsDetailViewController.closeDetail(sender:)),
                              for: .touchUpInside)
        view.bringSubviewToFront(closeButton)
        
        // Dismiss keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(FlocksListingsDetailViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    // Close Detail from Button
    @objc
    func closeDetail(sender: UIButton!){
        closeDetail()
    }
    
    // Close Detal from anywhere
    @objc
    func closeDetail(){
        dismiss(animated: true, completion: nil)
    }
    
    // Dismiss keyboard
    @objc
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
