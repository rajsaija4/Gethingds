//
//  MatchDetails.swift
//  Zodi
//
//  Created by GT-Ashish on 19/10/20.
//  Copyright © 2020 Gurutechnolabs. All rights reserved.
//

import Foundation
import SwiftyJSON

class MatchDetails: NSObject {
    
    var matchId: Int = 0
    var matchedUserId: String = ""
    var userImage: String = ""
    var matchUserImage: String = ""
    var matchUserName: String = ""
    var matchUserSignId: Int = 0
    var userSignId: Int = 0
    
    init(_ json: JSON) {
        super.init()
        
        matchId = json["match_id"].intValue
        matchedUserId = json["matched_user_id"].stringValue
        userImage = json["user_image_url"].stringValue
        matchUserImage = json["match_user_image_url"].stringValue
        matchUserName = json["match_user_name"].stringValue
        matchUserSignId = json["match_sun_zodiac_sign_id"].intValue
        userSignId = json["user_sun_zodiac_sign_id"].intValue
        
    }
    
}
