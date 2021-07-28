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
   
    @IBOutlet weak var btnReviewLater: UIButton!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var btnStatus: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupCell(user: Conversation) {
        if let imgURL = URL(string: user.userImage) {
            imgUser.kf.setImage(with: imgURL)
        }
        lblUserName.text = user.name
        let userStatus = user.readStatus == "unread" ? "img_active_user" : "img_inactive_user"
        //btnName.setImage(UIImage(named: userStatus), for: .normal)
    }
    

        func setupReviewLater(user: UserProfile) {
            if let imgURL = URL(string: user.image1) {
                imgUser.kf.setImage(with: imgURL)
            }
            lblUserName.text = user.firstName
            let userStatus = user.status == "active" ? "img_active_user" : "img_inactive_user"
            //btnName.setImage(UIImage(named: userStatus), for: .normal)
        }
    
    func setupMatchesList(user:MatchConversation) {
        
        if let imgURL = URL(string: user.userImage) {
            imgUser.kf.setImage(with: imgURL)
        }
        lblUserName.text = user.name
//        let userStatus = user. == "active" ? "img_active_user" : "img_inactive_user"
    }


}
