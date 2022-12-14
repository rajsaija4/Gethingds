//
//  MainTabBarController.swift
//  Zodi
//
//  Created by AK on 10/09/20.
//  Copyright © 2020 Gurutechnolabs. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.barTintColor = .white
        self.tabBar.unselectedItemTintColor = COLOR.darkBlack
        self.tabBar.tintColor = COLOR.App
    }

}



extension MainTabBarController {
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        switch item.title {
            case "PROFILE":
                break
            case "DISCOVER":
                guard let nvc = self.viewControllers?[1] as? UINavigationController else{ return }
                if let vc = nvc.viewControllers.first as? DiscoverVC {
                    vc.getPassion()
                    
                }
                break
        case "REVIEW LATER":
            guard let nvc = self.viewControllers?[2] as? UINavigationController else {
                return
            }
            if let vc = nvc.viewControllers.first as? ReviewLaterVC {
                vc.getProfiles()
            }
            case "CHAT":
                guard let nvc = self.viewControllers?[2] as? UINavigationController else{ return }
                if let vc = nvc.viewControllers.first as? ChatVC {
//                    vc.getConversation()
                }
                break
            default:
                break
        }
       
    }
}


extension MainTabBarController {
    
}
