//
//  ReportReason.swift
//  Zodi
//
//  Created by AK on 14/10/20.
//  Copyright © 2020 Gurutechnolabs. All rights reserved.
//

import Foundation
import SwiftyJSON


class ReportReason: NSObject {
    
    var id: Int = 0
    var icon: String = ""
    var message: String = ""
    
    init(_ json: JSON) {
        super.init()
        id = json["reason_id"].intValue
        icon = json["reason_icon"].stringValue
        message = json["reason_message"].stringValue
    }
    
}
