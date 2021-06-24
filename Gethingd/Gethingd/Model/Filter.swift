//
//  Filter.swift
//  Zodi
//
//  Created by AK on 26/09/20.
//  Copyright © 2020 Gurutechnolabs. All rights reserved.
//

import UIKit

struct Filter {
    static var minAge = 18
    static var maxAge = 100
    static var distance = 100
    static var minHeight = 36 // inch
    static var maxHeight = 119 // inch 
    static var sunSignId = 0
    static var moonSignId = 0
    static var risingSignId = 0

    
    static func reset() {
        minAge = 18
        maxAge = 40
        distance = 100
        minHeight = 140
        maxHeight = 200
        sunSignId = 0
        moonSignId = 0
        risingSignId = 0
    }
}
