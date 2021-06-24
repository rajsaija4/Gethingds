//
//  String+Ext.swift
//  Zodi
//
//  Created by GT-Ashish on 26/11/20.
//  Copyright © 2020 Gurutechnolabs. All rights reserved.
//

import Foundation
import SwiftyJSON

extension String {
    
    var jsonObject: JSON? {
        guard let data = self.data(using: .utf8) else { return nil }
        return JSON(data)
    }
    
}

