//
//  Passion .swift
//  Gethingd
//
//  Created by GT-Raj on 15/07/21.
//

import Foundation
import SwiftyJSON

class PassionSetting:NSObject {
    
    var noKids:Int = 0
    var passion:[TagList] = []
    var minimumAge:Int = 0
    var maximumAge:Int = 0
    
    
    init(json:JSON){
        super.init()
        
        noKids = json["data"]["no_of_kids"].intValue
        for data in json["data"]["passion"].arrayValue {
            passion.append(TagList(json: data))
        }
        minimumAge = json["data"]["minimum_age"].intValue
        maximumAge = json["data"]["maximum_age"].intValue
        
        
    }
    
}


class TagList: NSObject {
    var id:Int = 0
    var passion:String = ""
    
    init(json:JSON){
        super.init()
        
        id = json["id"].intValue
        passion = json["passion"].stringValue
    }
}


