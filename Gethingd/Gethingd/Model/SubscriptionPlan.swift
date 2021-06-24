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
    
    var type: String = ""
    var currencyCode: String = ""
    var boostCount: Int = 0
    var boostDuration: Int = 0
    var superLikeCount: Int = 0
    var likesCount: Int = 0
    var price: Double = 0.0
    var isActive = false
    var isDisplay = false
    var expiryDate: String = ""
    
    
    init(fjson: JSON) {
        super.init()
        
        type = fjson["free_plan"]["type"].stringValue
        currencyCode = fjson["free_plan"]["currency_code"].stringValue
        boostCount = fjson["free_plan"]["boost_count_per_month"].intValue
        boostDuration = fjson["free_plan"]["boost_duration_minutes"].intValue
        superLikeCount = fjson["free_plan"]["super_likes_per_day"].intValue
        likesCount = fjson["free_plan"]["likes_per_day"].intValue
        price = fjson["free_plan"]["price"].doubleValue
        isActive = fjson["free_plan"]["is_active"].boolValue
        expiryDate = fjson["free_plan"]["end_date"].stringValue
        
    }
    
    init(pjson: JSON) {
        super.init()
        
        type = pjson["super_gold_plans"]["type"].stringValue
        currencyCode = pjson["super_gold_plans"]["currency_code"].stringValue
        boostCount = pjson["super_gold_plans"]["boost_count_per_month"].intValue
        boostDuration = pjson["super_gold_plans"]["boost_duration_minutes"].intValue
        superLikeCount = pjson["super_gold_plans"]["super_likes_per_day"].intValue
        likesCount = pjson["super_gold_plans"]["likes_per_day"].intValue
        price = pjson["super_gold_plans"]["price"].doubleValue
        isActive = pjson["super_gold_plans"]["is_active"].boolValue
        expiryDate = pjson["super_gold_plans"]["end_date"].stringValue
        
    }
    
    init(fpjson: JSON) {
        super.init()
        
        type = fpjson["freemium_plan"]["type"].stringValue
        currencyCode = fpjson["freemium_plan"]["currency_code"].stringValue
        boostCount = fpjson["freemium_plan"]["boost_count_per_month"].intValue
        boostDuration = fpjson["freemium_plan"]["boost_duration_minutes"].intValue
        superLikeCount = fpjson["freemium_plan"]["super_likes_per_day"].intValue
        likesCount = fpjson["freemium_plan"]["likes_per_day"].intValue
        price = fpjson["freemium_plan"]["price"].doubleValue
        isActive = fpjson["freemium_plan"]["is_active"].boolValue
        isDisplay = fpjson["freemium_plan"]["is_display"].boolValue
        expiryDate = fpjson["freemium_plan"]["end_date"].stringValue
        
    }
    

}
