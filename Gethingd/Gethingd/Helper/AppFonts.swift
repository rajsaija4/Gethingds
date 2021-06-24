//
//  AppFonts.swift
//
//  Created by Ashish on 20/08/20.
//  Copyright © 2020 Ashish. All rights reserved.
//

import Foundation
import UIKit


enum AppFonts : String {
  
    case Poppins_Bold     = "Poppins-Bold"
    case Poppins_Light    = "Poppins-Light"
    case Poppins_Medium   = "Poppins-Medium"
    case Poppins_SemiBold = "Poppins-SemiBold"
    case Poppins_Regular  = "Poppins-Regular"
    
}

extension AppFonts {
    
    func withSize(_ fontSize: CGFloat) -> UIFont {
        
        return UIFont(name: self.rawValue, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
    }
    
    func withDefaultSize() -> UIFont {
        
        return UIFont(name: self.rawValue, size: 12.0) ?? UIFont.systemFont(ofSize: 12.0)
    }
    
}

// USAGE : let font = AppFonts.Helvetica.withSize(13.0)
// USAGE : let font = AppFonts.Helvetica.withDefaultSize()
