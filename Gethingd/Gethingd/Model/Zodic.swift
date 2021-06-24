//
//  Zodic.swift
//  Zodi
//
//  Created by AK on 23/09/20.
//  Copyright © 2020 Gurutechnolabs. All rights reserved.
//

import UIKit

extension String {
    
    var getSignURL: String {
        return "\(URLManager.mainBasePath)zodiac_sign/" + self + ".png"
    }
    
    var getActiveSignURL: String {
        return "\(URLManager.mainBasePath)zodiac_sign/" + self + "-active.png"
    }
    
    var getSignIconURL: String {
        return "\(URLManager.mainBasePath)zodiac_sign/zodi_icon/" + self + ".png"
    }
    
    var getActiveSignIconURL: String {
        return "\(URLManager.mainBasePath)zodiac_sign/zodi_icon/" + self + "-active.png"
    }
    
    var signName: String {
        
        switch self {
            case "1":
                return "Aries"
            case "2":
                return "Taurus"
            case "3":
                return "Gemini"
            case "4":
                return "Cancer"
            case "5":
                return "Leo"
            case "6":
                return "Virgo"
            case "7":
                return "Libra"
            case "8":
                return "Scorpio"
            case "9":
                return "Sagittarius"
            case "10":
                return "Capricorn"
            case "11":
                return "Aquarius"
            case "12":
                return "Pisces"
            default:
                return ""
        }
    }
    
}
