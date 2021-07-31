//
//  NewPasswordVC.swift
//  Gethingd
//
//  Created by RAJ J SAIJA on 23/07/21.
//

import UIKit

class NewPasswordVC: UIViewController {
    
    @IBOutlet weak var txtNewPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    
    var key:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
    }
    

    @IBAction func onPressresetBtn(_ sender: UIButton) {
        
        setupNewPassword()
        
        
    }
   
     @IBAction func onPressVisiblepassbtn(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        if sender.tag == 0 {
            txtNewPassword.isSecureTextEntry = !sender.isSelected
        }
        if sender.tag == 1 {
            txtNewPassword.isSecureTextEntry = !sender.isSelected
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

}


extension NewPasswordVC {
    
    
    func setupNewPassword() {
        
        guard let password = txtNewPassword.text, password.count > 0 else {
            self.showToast("Please Enter Password")
            return
        }
        
        guard let confirmpassword = txtConfirmPassword.text, password.count > 0 else {
            self.showToast("Please Enter Password")
            return
        }
        guard password == confirmpassword else {
            self.showToast("Please Enter Both Password Same")
            return
            
        }
        guard password.count >= 6 else {
            showToast("Password should be 6 or more then 6 characters")
            return
        }
        
        guard confirmpassword.count >= 6 else {
            showToast("Password should be 6 or more then 6 characters")
            return
        }
        
        let param = [
            
        "new_password":password,
        "confirm_password":confirmpassword,
        "key":key
        ] as [String:Any]
        showHUD()
        NetworkManager.Auth.updateNewpassword(param: param) { response in
            self.hideHUD()
            self.showToastWithDuration(response,5)
            APPDEL?.setupLogin()
        } _: { error in
            self.hideHUD()
            let alert = UIAlertController(title: "Oops!", message: error)
            self.present(alert, animated: true, completion: nil)
        }

        
        
    }
}
