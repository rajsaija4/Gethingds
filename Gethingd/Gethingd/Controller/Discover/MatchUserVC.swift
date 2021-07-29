//
//  MatchUserVC.swift
//  Zodi
//
//  Created by AK on 17/09/20.
//  Copyright © 2020 Gurutechnolabs. All rights reserved.
//

import UIKit
import SwiftyJSON

class MatchUserVC: UIViewController {

    
    //MARK:- VARIABLE
    var matchDetails: MatchDetails!
    
    //MARK:- OUTLET
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var imgOppsiteUser: UIImageView!
    
//    @IBOutlet weak var imgSignUser: UIImageView!
//    @IBOutlet weak var imgOppositeUserSign: UIImageView!
    @IBOutlet weak var lblMatch: UILabel!
    
    //MARK:- LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    
    
    
}



extension MatchUserVC {
        
    fileprivate func setupUI() {

        if let url = URL(string: matchDetails.userImage) {
            imgUser.kf.setImage(with: url)
        }

        if let url = URL(string: matchDetails.matchUserImage) {
            imgOppsiteUser.kf.setImage(with: url)
        }
        
        
        lblMatch.text = "You have matched with \(matchDetails.matchUserName). Send a message to start the conversation."

    }
}



extension MatchUserVC {

    @IBAction func onSendControlTap(_ sender: UIControl) {
        let vc = MessageVC.instantiate(fromAppStoryboard: .Chat)
        vc.hidesBottomBarWhenPushed = true
//        vc.onPopView = { [weak self] in
//            self?.getConversation()
//        }
//        vc.conversation = arrMatchesMessage[indexPath.row]
        vc.match_Id = matchDetails.matchId
        vc.userImage = matchDetails.matchUserImage
        vc.oppositeUserName = matchDetails.matchUserName
        self.navigationController?.pushViewController(vc, animated: true)
//        (ROOTVC as? UINavigationController)?.pushViewController(vc, animated: true)
    }

    @IBAction func onLaterControlTap(_ sender: UIControl) {
        APPDEL?.setupMainTabBarController()
    }

}
