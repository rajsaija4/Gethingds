//
//  NotificationCell.swift
//  Zodi
//
//  Created by AK on 16/09/20.
//  Copyright © 2020 Gurutechnolabs. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {
    
    
    //MARK:- VARIABLE
    
    //MARK:- OUTLET
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    
    //MARK:- LIFECYCLE

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(notification: AppNotification) {
        lblTitle.text = notification.title
        lblSubTitle.text = notification.message
        lblDate.text = notification.createdAt.displayTime
        imgUser.setImage(notification.imgUser)
    }
    
}
