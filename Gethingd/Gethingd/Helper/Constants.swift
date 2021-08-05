//
//  Constants.swift
//
//  Created by Ashish on 20/08/20.
//  Copyright © 2020 Ashish. All rights reserved.
//

import Foundation
import UIKit

let APPDEL                             =   (UIApplication.shared.delegate as? AppDelegate)
let APPNAME                            =   "ZoMate"
let APPID                              =   "1538258481"

let ROOTVC                              =   APPDEL?.window?.rootViewController
let MAIN_WINDOW                         =   UIApplication.shared.keyWindow
let NAV_HEIGHT                          =   UINavigationBar.appearance().frame.size.height + UIApplication.shared.statusBarFrame.size.height

let SCREEN_WIDTH                        =   UIScreen.main.bounds.width
let SCREEN_HEIGHT                       =   UIScreen.main.bounds.height
func SCREEN_WIDTH_CAL(orignalSize:CGFloat) -> CGFloat { return orignalSize * SCREEN_WIDTH / 375 }
func SCREEN_HEIGHT_CAL(orignalSize:CGFloat) -> CGFloat { return orignalSize * SCREEN_HEIGHT / 667 }

let GooglePlaceAPIKey = "AIzaSyBw44keQPj2qC2m7cAt9pXzQzbvGA3m3I8"

let APP_VERSION = "1.0"
