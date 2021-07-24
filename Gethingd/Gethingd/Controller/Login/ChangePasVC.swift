//
//  ChangePasVC.swift
//  Gethingd
//
//  Created by GT-Raj on 22/07/21.
//

import UIKit

class ChangePasVC: UIViewController {

    @IBOutlet weak var txtCurrentPassword: UITextField!
    @IBOutlet weak var txtNewPassword: UITextField!
    @IBOutlet weak var txtConfirmNewPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
    }
    

    @IBAction func onPressResetPassword(_ sender: UIButton) {
        
        
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


extension ChangePasVC {
    
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
