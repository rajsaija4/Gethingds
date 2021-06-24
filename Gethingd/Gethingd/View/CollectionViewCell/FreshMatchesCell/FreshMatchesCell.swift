//
//  FreshMatchesCell.swift
//  Zodi
//
//  Created by AK on 16/09/20.
//  Copyright © 2020 Gurutechnolabs. All rights reserved.
//

import UIKit
import Kingfisher

class FreshMatchesCell: UICollectionViewCell {

    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var btnName: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupCell(user: Conversation) {
        if let imgURL = URL(string: user.userImage) {
            imgUser.kf.setImage(with: imgURL)
        }
        btnName.setTitle(user.name, for: .normal)
        let userStatus = user.readStatus == "unread" ? "img_active_user" : "img_inactive_user"
        //btnName.setImage(UIImage(named: userStatus), for: .normal)
    }

}
