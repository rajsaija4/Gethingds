//
//  UpdateNowVC.swift
//  Zodi
//
//  Created by AK on 16/09/20.
//  Copyright © 2020 Gurutechnolabs. All rights reserved.
//
import UIKit

class UpdateNowVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    @IBAction func onUpdateNowControlTap(_ sender: UIControl) {
        if let url = URL(string: "http://itunes.apple.com/app/id\(APPID)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    

}
