//
//  FlocksListingsFlockDetailsView.swift
//  BirdsFlock
//
//  Created by Guillermo Irigoyen on 10/29/18.
//  Copyright © 2018 Guillermo Irigoyen. All rights reserved.
//

import Foundation
import UIKit

class  FlocksListingsFlockDetailsView : UIView {
    
    @IBOutlet weak var flockScrollView: UIScrollView!
    @IBOutlet weak var flockIdLabel: UILabel!
    @IBOutlet weak var flockIdTextInput: UITextField!
    @IBOutlet weak var flockCountLabel: UILabel!
    @IBOutlet weak var flockCountTextInput: UITextField!
    @IBOutlet weak var flockSaveButton: UIButton!
    
    var flock : Flock?
    var detailMode : DetailMode!
    
    
    // Overrides
    override func layoutSubviews() {
        setupViewFor(mode: detailMode)
        setupActions()
    }
    
    
    // Setup View
    private func setupViewFor(mode: DetailMode = .edit){
        flockScrollView.contentSize = CGSize(width: flockScrollView.frame.width,
                                             height: flockScrollView.frame.height * 1.5)
        switch mode {
        case .new:
            flockIdLabel.isHidden     = true
            flockCountLabel.isHidden  = true
            break
            
        case .edit:
            if let f = flock {
                flockIdLabel.text        = String(f.id)
                flockCountLabel.text     = String(f.count)
                flockIdTextInput.text    = String(f.id)
                flockCountTextInput.text = String(f.count)
            }
            break
            
        case .view:
            flockIdTextInput.isHidden    = true
            flockCountTextInput.isHidden = true
            flockSaveButton.isHidden     = true
            if let f = flock {
                flockIdLabel.text        = String(f.id)
                flockCountLabel.text     = String(f.count)
            }
            break
        }
        
    }
    
    // Setup ACtions
    private func setupActions(){
        // Save
        flockSaveButton.addTarget(self, action: #selector(FlocksListingsFlockDetailsView.saveFlock(sender:)), for: .touchUpInside)
        
    }
    
    // Save city
    @objc
    func saveFlock(sender: UIButton!){
        print("Save Flock")
        checkData()
        
    }
    
}

extension FlocksListingsFlockDetailsView {
    
    // Checks
    private func checkData(){
        
        // ID
        // Check if there is input and could be converted to an int
        let aFlockId = flockIdTextInput.text?.integerValue
        if aFlockId == nil {
            showAlert(withMessage: TEXT_FLOCK_INVALID_ID)
            return
            
        }
        
        // Check if there is not another one with the same ID
        if DATAMANAGER.flocksIndex.contains((flockIdTextInput.text?.lowercased())!){
            showAlert(withMessage: TEXT_FLOCK_EXIST_ERROR_MESSAGE)
            return
            
        }
        
        // COUNT
        // Check if there is input and could be converted to an int
        let aFlockCount = flockCountTextInput.text?.integerValue
        if aFlockCount == nil || aFlockCount! <= 1 {
            showAlert(withMessage: TEXT_FLOCK_WRONG_COUNT)
            return
        }
        
        let aFlock = Flock(id:aFlockId!, count: aFlockCount!)
        save(flock: aFlock)
        
    }
    
    // Error
    private func showAlert(withMessage aMessage: String){
        print("ERROR: \(aMessage)")
        VIEWCOORDINATOR.showAlert(withTitle: TEXT_FLOCK_ERROR_TITLE, andMessage: aMessage)
        
    }
    
    // Save
    private func save(flock: Flock){
        print("Saving new flock")
        DATAMANAGER.addNewFlock(flock)
        VIEWCOORDINATOR.popViewController()
    }
    
}
