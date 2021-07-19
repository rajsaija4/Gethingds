//
//  SubscriptionPlan.swift
//  Zodi
//
//  Created by GT-Ashish on 31/10/20.
//  Copyright © 2020 Gurutechnolabs. All rights reserved.
//

import Foundation
import SwiftyJSON

class SubscriptionPlan: NSObject {
    
    var title: String = ""
    var details: String = ""
    var currency_code: String = ""
    var likes_per_day: Int = 0
    var review_later_per_day: Int = 0
    var is_active: Int = 0
  
    
    
    init(fjson: JSON) {
        super.init()
        
        title = fjson["data"]["free_plan"]["title"].stringValue
        details = fjson["data"]["free_plan"]["description"].stringValue
        currency_code = fjson["data"]["free_plan"]["currency_code"].stringValue
        likes_per_day = fjson["data"]["free_plan"]["likes_per_day"].intValue
        review_later_per_day = fjson["data"]["free_plan"]["review_later_per_day"].intValue
        is_active = fjson["data"]["free_plan"]["is_active"].intValue
     
        
    }
    
    init(pjson: JSON) {
        super.init()
        
        
        title = pjson["data"]["premium_plan"]["title"].stringValue
        details = pjson["data"]["premium_plan"]["description"].stringValue
        currency_code = pjson["data"]["premium_plan"]["currency_code"].stringValue
        likes_per_day = pjson["data"]["premium_plan"]["likes_per_day"].intValue
        review_later_per_day = pjson["data"]["premium_plan"]["review_later_per_day"].intValue
        is_active = pjson["data"]["premium_plan"]["is_active"].intValue
     
        
    }

}
