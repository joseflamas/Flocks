//
//  FlocksExplorerMapCityAnnotationView.swift
//  BirdsFlock
//
//  Created by Guillermo Irigoyen on 10/23/18.
//  Copyright © 2018 Guillermo Irigoyen. All rights reserved.
//

import Foundation
import UIKit

class FlocksExplorerMapCityAnnotationView : UIView, UITextFieldDelegate {
    
    @IBOutlet weak var cityIcon: UIImageView!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var cityCapacity: UILabel!
    @IBOutlet weak var cityCapacityLeft: UILabel!
    @IBOutlet weak var cityCapacityProgress: UIProgressView!
    
    @IBOutlet weak var cityInfoDetail: UIButton!
    
    var city: City!
    
    // Overrides
    override func awakeFromNib() {
        super.awakeFromNib()
        setupDetailViewStyle()
    }
    
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // If user touched the info button
        if let result = cityInfoDetail.hitTest(convert(point, to: cityInfoDetail), with: event) {
            return result
        }
        // If the user touched everything else
        return self
    }
    
    // Utilities
    func fillAnnotationWithCity(_ aCity:City){
        city = aCity
        cityName.text = city.name.capitalized
        cityCapacity.text = city.capacity == 0 ? "Unlimited" : String(city.capacity)
        cityCapacityLeft.text = city.capacity == 0 ? "Unlimited" : String(Int(city.capacity)-Int(city.capacityTaken))
        cityInfoDetail.addTarget(self,
                                 action: #selector(FlocksExplorerMapCityAnnotationView.gotoDetail(sender:)),
                                 for: .touchUpInside)
        
        updateCapacityProgress()
    }
    
    func updateCapacityProgress(){
        cityCapacityProgress.setProgress(city.capacityLeft, animated: true)
    }
    
    // View Style
    func setupDetailViewStyle(){
        layer.cornerRadius = 10
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.lightGray.cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 3, height: 3)
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 4.0
    }
    
    // Actions
    @objc
    func gotoDetail(sender: UIButton!){
        print("Displaying \(city.name.uppercased()) info ...")
        
        let infoView : FlocksListingsDetailViewController
        infoView = FlocksListingsDetailViewController(nibName: "FlocksListingsDetailViewController",
                                                      bundle: .main,
                                                      type: .city,
                                                      mode: .view)
        infoView.dataObject = city

        VIEWCOORDINATOR.pushViewController(infoView)
       
    }
    
}
