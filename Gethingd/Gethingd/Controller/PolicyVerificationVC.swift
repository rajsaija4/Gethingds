//
//  PolicyVerificationVC.swift
//  Gethingd
//
//  Created by GT-Raj on 06/07/21.
//

import UIKit

class PolicyVerificationVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onPressAcceptbtnTap(_ sender: UIButton) {
        
        APPDEL?.setupCreateProfileVC()
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
