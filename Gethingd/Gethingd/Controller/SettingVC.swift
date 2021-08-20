//
//  SettingVC.swift
//  Gethingd
//
//  Created by GT-Raj on 06/07/21.
//

import UIKit
 

class SettingVC: UITableViewController {

    @IBOutlet weak var showNotification: UISwitch!
    @IBOutlet weak var switchDistance: UISwitch!
    @IBOutlet weak var switchAge: UISwitch!
    var ageshow = 0
    var distance = 0
    var notification = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getSetting()
      
        navigationController?.navigationBar.isHidden = true

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    @IBAction func onPressbackbtn(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func switchAge(_ sender: UISwitch) {
        
        if sender.isOn {
            ageshow = 1
            
            if switchDistance.isOn {
                distance = 1
            }
            
            if showNotification.isOn {
                notification = 1
            }
            
        updateSetting(age: ageshow, distance: distance, notification: notification)
        }
        
        else {
            ageshow = 0
            
            if switchDistance.isOn {
                distance = 1
            }
            
            if showNotification.isOn {
                notification = 1
            }
            
        updateSetting(age: ageshow, distance: distance, notification: notification)
        }
        
        
        
    }
    @IBAction func DistanceVisible(_ sender: UISwitch) {
        
        if sender.isOn {
            distance = 1
            
            if switchAge.isOn {
                ageshow = 1
            }
            
            if showNotification.isOn {
                notification = 1
            }
            
        updateSetting(age: ageshow, distance: distance, notification: notification)
        }
        
        else {
            distance = 0
            
            if switchAge.isOn {
                ageshow = 1
            }
            
            if showNotification.isOn {
                notification = 1
            }
            
        updateSetting(age: ageshow, distance: distance, notification: notification)
        }
        
        
    }
    @IBAction func showNotification(_ sender: UISwitch) {
        
        
        if sender.isOn {
            notification = 1
            
            if switchAge.isOn {
                ageshow = 1
            }
            
            if switchDistance.isOn {
                distance = 1
            }
            
        updateSetting(age: ageshow, distance: distance, notification: notification)
        }
        
        else {
            notification = 0
            
            if switchAge.isOn {
                ageshow = 1
            }
            
            if switchDistance.isOn {
                distance = 1
            }
            
        updateSetting(age: ageshow, distance: distance, notification: notification)
        }
        
    }
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 3:
            switch indexPath.row {
            case 0:
                
                guard let termsURL = URL(string: URLManager.PrivacyPolicy.disclaimer) else {
                    return
                }
                openSafariViewController(termsURL)
            case 1:
                guard let termsURL = URL(string: URLManager.PrivacyPolicy.cookie) else {
                    return
                }
                openSafariViewController(termsURL)
            case 2:
                guard let termsURL = URL(string: URLManager.PrivacyPolicy.dataProcess) else {
                    return
                }
                openSafariViewController(termsURL)
                
            
            default:
                break
            }
            
       
        default:
            break
        }
    }
}


extension SettingVC {
    
    func getSetting() {
        showHUD()
        NetworkManager.Setting.getUserSetting { (response) in
            print(response)
            let shownotification = response["data"]["show_notification"].intValue
            let sowmyage = response["data"]["show_my_age"].intValue
            let distanceVisible = response["data"]["distance_visible"].intValue
            
            if shownotification == 1{
                self.showNotification.isOn = true
            }
            
            else {
                self.showNotification.isOn = false
            }
            
            if sowmyage == 1{
                self.switchAge.isOn = true
            }
            
            else {
                self.switchAge.isOn = false
            }
            
            if distanceVisible == 1{
                self.switchDistance.isOn = true
            }
            
            else {
                self.switchDistance.isOn = false
            }
            self.hideHUD()
        } _: { (fail) in
            self.showToast("error in fetch user setting")
            self.hideHUD()
        }

    }
    
    func updateSetting(age:Int,distance:Int,notification:Int) {
        
        let param = [
            "show_my_age": age,
            "distance_visible":distance ,
            "show_notification":notification
        ] as [String : Any]
        
        NetworkManager.Setting.updateUserSetting(param: param) { (response) in
            self.showToast(response)
        } _: { (error) in
            self.showToast(error)
        }

        
    }
}


