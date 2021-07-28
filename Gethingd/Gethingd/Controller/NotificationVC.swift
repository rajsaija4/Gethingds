//
//  NotificationVC.swift
//  Zodi
//
//  Created by AK on 16/09/20.
//  Copyright © 2020 Gurutechnolabs. All rights reserved.
//

import UIKit

class NotificationVC: UIViewController {
    
    
    //MARK:- VARIABLE
    var isFromNotification = false
    var onPopView: (() -> Void)?
    fileprivate var arrNotification: [AppNotification] = []
    
    //MARK:- OUTLET
    @IBOutlet weak var tblNotification: UITableView!{
        didSet{
            tblNotification.register(NotificationCell.self)
        }
    }
    @IBOutlet weak var stackNoNotification: UIStackView!
    
    //MARK:- LIFECYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    
}



extension NotificationVC {
    
    fileprivate func setupUI() {
        navigationItem.setHidesBackButton(true, animated: true)
        navigationController?.addBackButtonWithTitle(title: "Notification", action: #selector(self.onBackBtnTap))
        getNotifications()
    }
}



extension NotificationVC {
    
    fileprivate func getNotifications() {
        showHUD()
        NetworkManager.NotificationData.getNotification({ (notifications) in
            self.hideHUD()
            self.arrNotification.removeAll()
            self.arrNotification.append(contentsOf: notifications)
            self.tblNotification.reloadData()
            self.setupNoNotificationView()
            
        }) { (error) in
            self.hideHUD()
            self.showToast(error)
            self.setupNoNotificationView()
        }
    }
    
    fileprivate func setupNoNotificationView() {
        stackNoNotification.isHidden = arrNotification.count != 0
        tblNotification.isHidden = arrNotification.count == 0
    }
}


extension NotificationVC {
    
    @objc fileprivate func onBackBtnTap() {
        
        if isFromNotification {
            APPDEL?.setupMainTabBarController()
            return
        }
        
        onPopView?()
        navigationController?.popViewController(animated: false)
    }
}



extension NotificationVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrNotification.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NotificationCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.setupCell(notification: arrNotification[indexPath.row])
        return cell
    }
}



extension NotificationVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if arrNotification[indexPath.row].type == "message" {
            guard let mainTVC = (APPDEL?.window?.rootViewController as? UINavigationController)?.viewControllers.first as? MainTabBarController else { return }
            mainTVC.selectedIndex = 2
            guard let chatVC = (mainTVC.viewControllers?.last as? UINavigationController)?.viewControllers.first as? ChatVC else { return }
//            chatVC.getConversation()
            return
        }
        
        if arrNotification[indexPath.row].type == "match" {
            guard let mainTVC = (APPDEL?.window?.rootViewController as? UINavigationController)?.viewControllers.first as? MainTabBarController else { return }
            mainTVC.selectedIndex = 2
            guard let chatVC = (mainTVC.viewControllers?.last as? UINavigationController)?.viewControllers.first as? ChatVC else { return }
//            chatVC.getConversation()
            return
        }
        
        if arrNotification[indexPath.row].type == "astro_like" {
            let vc = UserDetailsTVC.instantiate(fromAppStoryboard: .Discover)
            vc.isFromNotification = true
            vc.userId = arrNotification[indexPath.row].senderId
            let nvc = UINavigationController(rootViewController: vc)
            nvc.isNavigationBarHidden = false
            APPDEL?.window?.rootViewController = nvc
            APPDEL?.window?.makeKeyAndVisible()
            return
        }
        
        if arrNotification[indexPath.row].type == "premium" {
            let vc = UpgradeVC.instantiate(fromAppStoryboard: .Upgrade)
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: false)
            return
        }
        
        
    }

}
