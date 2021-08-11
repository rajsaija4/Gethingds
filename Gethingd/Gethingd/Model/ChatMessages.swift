//
//  ChatMessages.swift
//  Gethingd
//
//  Created by GT-Raj on 28/07/21.
//

import Foundation
import SwiftyJSON

class ChatMessages: NSObject {
    
    var userId:Int = 0
    var userName:String = ""
    var userImage:String = ""
    var message:String = ""
    var unreadMessageCount:Int = 0
    var readStatus:String = ""
    var likeStatus:String = ""
    var matchId:Int = 0
    var createAt:String = ""
    var lastSeen:Double = 0.0
    
    init(json:JSON) {
        super.init()
        
        userId = json["user_id"].intValue
        userName = json["user_name"].stringValue
        userImage = json["user_image_url"].stringValue
        message = json["message"].stringValue
        unreadMessageCount = json["unread_message_count"].intValue
        readStatus = json["read_status"].stringValue
        likeStatus = json["like_status"].stringValue
        matchId = json["match_id"].intValue
        createAt = json["created_at"].stringValue
        lastSeen = json["lastseen"].doubleValue
    }
    
    init( _ json:JSON) {
        super.init()
        
        userId = json["message"]["user_id"].intValue
        userName = json["message"]["name"].stringValue
        userImage = json["message"]["sender_user_image"].stringValue
        message = json["message"]["message"].stringValue
        unreadMessageCount = json["message"]["unread_message_count"].intValue
        readStatus = json["message"]["read_status"].stringValue
        likeStatus = json["message"]["like_status"].stringValue
        matchId = json["message"]["match_id"].intValue
        createAt = json["message"]["created_at"].stringValue
        lastSeen = json["message"]["lastseen"].doubleValue
    }
    
}
