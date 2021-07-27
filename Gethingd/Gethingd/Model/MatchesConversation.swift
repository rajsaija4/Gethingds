//
//  MatchesConversation.swift
//  Gethingd
//
//  Created by GT-Raj on 27/07/21.
//

import Foundation
import SwiftyJSON


class MatchesConversation: NSObject {
    
    var newMatchCount:Int = 0
    var conversationNotStartedArray:[MatchConversation] = []
    
    init(json:JSON){
        super.init()
        
        newMatchCount = json["new_match_count"].intValue
        for notStartedChat in json["conversation_not_started_array"].arrayValue {
            conversationNotStartedArray.append(MatchConversation(json: notStartedChat))
        }
    }
    
    
    
}


class MatchConversation:NSObject {
    
    var userId:Int = 0
    var name:String = ""
    var userImage:String = ""
    var readStatus:String = ""
    var likeStatus:String = ""
    var matchId:Int = 0
    var createDate:String = ""
    
    
    init(json:JSON){
        super.init()
        
        userId = json["user_id"].intValue
        name = json["user_name"].stringValue
        userImage = json["image1"].stringValue
        readStatus = json["read_status"].stringValue
        likeStatus = json["like_status"].stringValue
        matchId = json["match_id"].intValue
        createDate = json["created_date"].stringValue
        
    }
    
    
    
    
    
}
