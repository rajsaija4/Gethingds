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
    
    @IBOutlet weak var imgSignUser: UIImageView!
    @IBOutlet weak var imgOppositeUserSign: UIImageView!
    @IBOutlet weak var lblMatch: UILabel!
    
    //MARK:- LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupUI()
        
    }
    
    
    
}



//extension MatchUserVC {
        
//    fileprivate func setupUI() {
//
//        if let url = URL(string: matchDetails.userImage) {
//            imgUser.kf.setImage(with: url)
//        }
//
//        if let url = URL(string: matchDetails.matchUserImage) {
//            imgOppsiteUser.kf.setImage(with: url)
//        }
//
//        if let url = URL(string: "\(matchDetails.userSignId)".getSignIconURL) {
//            imgSignUser.kf.setImage(with: url)
//        }
//
//        if let url = URL(string: "\(matchDetails.matchUserSignId)".getSignIconURL) {
//            imgOppositeUserSign.kf.setImage(with: url)
//        }
//
//        lblMatch.text = "You have matched with \(matchDetails.matchUserName). Send a message to start the conversation."
//
//    }
//}



//extension MatchUserVC {
//
//    @IBAction func onSendControlTap(_ sender: UIControl) {
//        let vc = MessageVC.instantiate(fromAppStoryboard: .Chat)
//        vc.hidesBottomBarWhenPushed = true
//        vc.conversation = Conversation(json: JSON.null, matchId: matchDetails.matchId, name: matchDetails.matchUserName)
//        vc.userImage = matchDetails.matchUserImage
//        vc.onPopView = {
//            self.dismiss(animated: true, completion: nil)
//        }
//        navigationController?.pushViewController(vc, animated: false)
//    }
//
//    @IBAction func onLaterControlTap(_ sender: UIControl) {
//        APPDEL?.setupMainTabBarController()
//    }
//
//}
