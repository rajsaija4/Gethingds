//
//  ChangePasswordVC.swift
//  Zodi
//
//  Created by AK on 25/09/20.
//  Copyright © 2020 Gurutechnolabs. All rights reserved.
//

import UIKit

class ChangePasswordVC: UIViewController {
    
    //MARK:- VARIABLE
    
    //MARK:- OUTLET
    @IBOutlet weak var txtCurrentPassword: UITextField!
    @IBOutlet weak var txtNewPassword: UITextField!
    @IBOutlet weak var txtConfirmNewPassword: UITextField!
    
    //MARK:- LIFECYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setHidesBackButton(true, animated: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.isNavigationBarHidden = false
    }
    

    
}

extension ChangePasswordVC {
    
    fileprivate func changePassword(param: [String: String]) {
        
        showHUD()
        
        NetworkManager.Auth.changePassword(param: param, { (message) in
            self.hideHUD()
            let alert = UIAlertController(title: "Change Password", message: message, actionName: "Ok") { (_) in
                self.navigationController?.popViewController(animated: true)
            }
            self.present(alert, animated: true, completion: nil)
        }, { (error) in
            self.hideHUD()
            self.showToast(error)
        })
        
    }
    
}



extension ChangePasswordVC {
    
    @IBAction func onBackBtnTap(_ sender: UIButton) {
        navigationController?.popViewController(animated: false)
    }
    
    @IBAction func onUpdatePasswordBtnTap(_ sender: UIControl) {
        
        guard let currentPassword = txtCurrentPassword.text, currentPassword.count > 0 else {
            showToast("Please \(txtCurrentPassword.placeholder ?? "")")
            return
        }
        
        guard let newPassword = txtNewPassword.text, newPassword.count > 0 else {
            showToast("Please \(txtNewPassword.placeholder ?? "")")
            return
        }
        
        guard newPassword.count >= 6 else {
            showToast("Password should be 6 or more then 6 characters")
            return
        }
        
        guard let confirmPassword = txtConfirmNewPassword.text, confirmPassword.count > 0 else {
            showToast("Please \(txtConfirmNewPassword.placeholder ?? "")")
            return
        }
        
        guard newPassword == confirmPassword else {
            showToast("New Password and Confirm Password must be same")
            return
        }
        
        
        let param = [
            "old_password": currentPassword,
            "new_password": newPassword,
            "confirm_password": confirmPassword
        ]
        
        changePassword(param: param)
    }
    
}
