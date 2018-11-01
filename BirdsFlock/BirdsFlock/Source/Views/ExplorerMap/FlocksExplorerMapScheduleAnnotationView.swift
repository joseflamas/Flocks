//
//  FlocksExplorerMapScheduleAnnotationView.swift
//  BirdsFlock
//
//  Created by Guillermo Irigoyen on 10/23/18.
//  Copyright © 2018 Guillermo Irigoyen. All rights reserved.
//

import Foundation
import UIKit

class FlocksExplorerMapScheduleAnnotationView : UIView {
    
    @IBOutlet weak var scheduleIcon: UIImageView!
    @IBOutlet weak var scheduleFlockId: UILabel!
    @IBOutlet weak var scheduleStatus: UILabel!
    @IBOutlet weak var scheduleOriginCity: UILabel!
    @IBOutlet weak var scheduleDestinyCity: UILabel!
    @IBOutlet weak var scheduleBeginDate: UILabel!
    @IBOutlet weak var scheduleEndDate: UILabel!
    @IBOutlet weak var scheduleInfoDetail: UIButton!
    
    var schedule: Schedule!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupDetailViewStyle()
    }
    
    // Info Button
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // If user touched the info button
        if let result = scheduleInfoDetail.hitTest(convert(point, to: scheduleInfoDetail), with: event) {
            return result
        }
        // If the user touched everything else
        return self
    }
    
    func fillAnnotationWithSchedule(_ aSchedule:Schedule){
        schedule = aSchedule
        scheduleFlockId.text = String(schedule.flock.id)
        scheduleOriginCity.text  = schedule.originCity.name
        scheduleDestinyCity.text = schedule.destinyCity.name
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyy hh:mm a"
        scheduleBeginDate.text   = dateFormatter.string(from: schedule.startDate)
        scheduleEndDate.text     = dateFormatter.string(from: schedule.endDate)
        
        scheduleInfoDetail.addTarget(self, action: #selector(FlocksExplorerMapScheduleAnnotationView.gotoDetail(sender:)), for: .touchUpInside)
        
        updateScheduleStatus(aStatus: (schedule.status?.description)!)
    }
    
    func updateScheduleStatus(aStatus:String){
        scheduleStatus.text = aStatus.uppercased()
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
        print("Displaying Schedule \(schedule.scheduleId.description) info ...")
        
        let infoView : FlocksListingsDetailViewController
        infoView = FlocksListingsDetailViewController(nibName: "FlocksListingsDetailViewController", bundle: .main, type: .schedule, mode: .view)
        infoView.dataObject = schedule
        
        VIEWCOORDINATOR.pushViewController(infoView)
    }
    
}
