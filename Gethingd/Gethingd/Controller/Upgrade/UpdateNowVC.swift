//
//  UpdateNowVC.swift
//  Zodi
//
//  Created by AK on 16/09/20.
//  Copyright © 2020 Gurutechnolabs. All rights reserved.
//
import UIKit

class UpdateNowVC: UIViewController {
    
    
    var header:String = ""
    var message:String = ""
    @IBOutlet weak var txtTitle: UILabel!
    @IBOutlet weak var txtMessage: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        txtTitle.text = header
        txtMessage.text = message

       
    }
    
    @IBAction func onUpdateNowControlTap(_ sender: UIControl) {
        if sender.tag == 0 {
            let vc = SubscribeVC.instantiate(fromAppStoryboard: .Upgrade)
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
            self.dismiss(animated: true, completion: nil)
        }
        
        if sender.tag == 1 {
            self.dismiss(animated: true, completion: nil)
        }
//        if let url = URL(string: "http://itunes.apple.com/app/id\(APPID)") {
//            UIApplication.shared.open(url, options: [:], completionHandler: nil)
//        }
    }
    

}
