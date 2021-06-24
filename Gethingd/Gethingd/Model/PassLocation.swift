//
//  PassLocation.swift
//  Zodi
//
//  Created by GT-Ashish on 24/10/20.
//  Copyright © 2020 Gurutechnolabs. All rights reserved.
//

import Foundation
import SwiftyJSON

class PassLocation: NSObject {
    
    var id: Int = 0
    var location: String = ""
    var latitude: String = ""
    var longitude: String = ""
    var isActive: Bool = false
    
    init(_ json: JSON) {
        super.init()
        
        id = json["id"].intValue
        location = json["location"].stringValue
        latitude = json["latitude"].stringValue
        longitude = json["longitude"].stringValue
        isActive = json["default"].stringValue == "Active"
    }
    
}


