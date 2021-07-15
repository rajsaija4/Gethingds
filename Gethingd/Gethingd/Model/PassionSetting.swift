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
    
    
    init(json:JSON){
        super.init()
        
        noKids = json["data"]["no_of_kids"].intValue
        for data in json["data"]["passion"].arrayValue {
            passion.append(TagList(json: data))
        }
        
        
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


