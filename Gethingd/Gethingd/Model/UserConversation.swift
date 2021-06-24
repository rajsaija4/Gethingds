//
//  UserConversation.swift
//  Zodi
//
//  Created by AK on 13/10/20.
//  Copyright © 2020 Gurutechnolabs. All rights reserved.
//

import Foundation
import SwiftyJSON

class UserConversation: NSObject {
    
    var likesCount: Int = 0
    var newMatchCount: Int = 0
    var unReadCount: Int = 0
    var arrConversationStarted: [Conversation] = []
    var arrConversationNotStarted: [Conversation] = []
    var arrAstroLikeUser: [Conversation] = []
    
    init(_ json: JSON) {
        super.init()
        
        likesCount = json["likes_count"].intValue
        newMatchCount = json["new_match_count"].intValue
        unReadCount = json["unread_count"].intValue
        
        for conversaton in json["conversation_started_array"].arrayValue {
            arrConversationStarted.append(Conversation(conversaton))
        }
        
        for conversaton in json["conversation_not_started_array"].arrayValue {
            arrConversationNotStarted.append(Conversation(conversaton))
        }
        
        for conversaton in json["astro_like_user"].arrayValue {
            arrAstroLikeUser.append(Conversation(conversaton))
        }
    }
}



class Conversation: NSObject {
    
    var userId: Int = 0
    var name: String = ""
    var userImage: String = ""
    var readStatus: String = ""
    var likeStatus: String = ""
    var message: String = ""
    var matchId: Int = 0
    var createdDate: String = ""
    var unreadMessageCount: Int = 0
    
    
    init(_ json: JSON) {
        super.init()
        userId = json["user_id"].intValue
        name = json["user_name"].stringValue
        userImage = json["user_image_url"].stringValue
        readStatus = json["read_status"].stringValue
        likeStatus = json["like_status"].stringValue
        matchId = json["match_id"].intValue
        message = json["message"].stringValue
        createdDate = json["created_date"].stringValue
        unreadMessageCount = json["unread_message_count"].intValue
    }
    
    init(json: JSON) {
        super.init()
        userId = json["message"]["user_id"].intValue
        name = json["message"]["user_name"].stringValue
        userImage = json["message"]["user_image_url"].stringValue
        readStatus = json["message"]["read_status"].stringValue
        likeStatus = json["message"]["like_status"].stringValue
        matchId = json["message"]["match_id"].intValue
        message = json["message"]["message"].stringValue
        createdDate = json["message"]["created_date"].stringValue
        unreadMessageCount = json["message"]["unread_message_count"].intValue
    }
    
    init(json: JSON, matchId: Int, name: String) {
        super.init()
        userId = json["user_id"].intValue
        self.name = name
        userImage = json["user_image_url"].stringValue
        readStatus = json["read_status"].stringValue
        likeStatus = json["like_status"].stringValue
        self.matchId = matchId
        message = json["message"].stringValue
        createdDate = json["created_date"].stringValue
        unreadMessageCount = json["unread_message_count"].intValue
    }
 
}

