//
//  Filter.swift
//  Zodi
//
//  Created by AK on 26/09/20.
//  Copyright © 2020 Gurutechnolabs. All rights reserved.
//

import UIKit

struct Filter {
    static var lookingFor = ""
    static var minAge = 0
    static var defaultMinAge = 0
    static var defaultMaximumAge = 0
    static var defaultMinKids = 0
    static var defaultMaxKids = 0
    static var maxAge = 0
    static var distance = 0
    static var minKid = 0  // inch
    static var maxKid = 0 // inch
    static var latitude = "0.0"
    static var longitude = "0.0"
    static var place = ""
 

    
    static func reset() {
      
        lookingFor = "both"
        minAge = 18
        maxAge = 100
        distance = 0
        minKid = 0
        maxKid = 3
        latitude = "0.0"
        longitude = "0.0"
        place = "rajkot"
       
    }
}
