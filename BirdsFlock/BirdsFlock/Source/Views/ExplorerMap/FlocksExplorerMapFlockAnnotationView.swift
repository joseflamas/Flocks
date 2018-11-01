//
//  FlocksExplorerMapFlockAnnotationView.swift
//  BirdsFlock
//
//  Created by Guillermo Irigoyen on 10/23/18.
//  Copyright © 2018 Guillermo Irigoyen. All rights reserved.
//

import Foundation
import UIKit

class FlocksExplorerMapFlockAnnotationView : UIView {
    
    @IBOutlet weak var flockIcon: UIImageView!
    @IBOutlet weak var flockId: UILabel!
    @IBOutlet weak var flockCount: UILabel!
    @IBOutlet weak var flockStatus: UILabel!
    @IBOutlet weak var flockInfoDetail: UIButton!
    
    var flock: Flock!
    
    // Overrides
    override func awakeFromNib() {
        super.awakeFromNib()
        setupDetailViewStyle()
    }
    
    // Info Button
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // If user touched the info button
        if let result = flockInfoDetail.hitTest(convert(point, to: flockInfoDetail), with: event) {
            return result
        }
        // If the user touched everything else
        return self
        
    }
    
    func fillAnnotationWithFlock(_ aFlock:Flock){
        flock = aFlock
        flockId.text     = String(flock.id)
        flockCount.text  = String(flock.count)
        flockInfoDetail.addTarget(self,
                                  action: #selector(FlocksExplorerMapFlockAnnotationView.gotoDetail(sender:)),
                                  for: .touchUpInside)

        updateFlockStatus(aStatus:(flock.status?.description)!)
        
    }
    
    func updateFlockStatus(aStatus:String){
        flockStatus.text = aStatus.uppercased()
        
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
        print("Displaying Flock \(String(flock.id).uppercased()) info ...")
        
        let infoView : FlocksListingsDetailViewController
        infoView = FlocksListingsDetailViewController(nibName: "FlocksListingsDetailViewController",
                                                      bundle: .main,
                                                      type: .flock,
                                                      mode: .view)
        infoView.dataObject = flock
        
        VIEWCOORDINATOR.pushViewController(infoView)
        
    }
    
}
