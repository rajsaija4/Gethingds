//
//  Filter.swift
//  Zodi
//
//  Created by AK on 26/09/20.
//  Copyright © 2020 Gurutechnolabs. All rights reserved.
//

import UIKit

struct Filter {
    static var filterApply = false
    static var lookingFor = "both"
    static var minAge = 0
    static var maxAge = 0
    static var distance = 0
    static var minKid = 0  // inch
    static var maxKid = 100 // inch
    static var latitude = "0.0"
    static var longitude = "0.0"
 

    
    static func reset() {
        filterApply = false
        lookingFor = "both"
        minAge = 18
        maxAge = 40
        distance = 100
        minKid = 0
        maxKid = 100
        latitude = "0.0"
        longitude = "0.0"
       
    }
}
