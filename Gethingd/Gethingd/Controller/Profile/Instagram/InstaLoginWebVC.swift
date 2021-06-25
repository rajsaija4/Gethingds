//
//  InstaLoginWebVC.swift
//  Zodi
//
//  Created by GT-Ashish on 19/03/21.
//  Copyright © 2021 Gurutechnolabs. All rights reserved.
//

import UIKit
import WebKit

class InstaLoginWebVC: UIViewController, WKNavigationDelegate{
    
    var instaGramUser: ((InstagramTestUser) -> ())?
    
    @IBOutlet var webView: WKWebView! {
        didSet {
            webView.navigationDelegate = self
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        InstagramApi.shared.authorizeApp { (url) in
            guard let newURL = url else { return }
            DispatchQueue.main.async {
                self.webView.load(URLRequest(url: newURL))
            }
        }
    }
    
    @IBAction func onBackBtnTap(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let request = navigationAction.request
        InstagramApi.shared.getTestUserIDAndToken(request: request) { [weak self] (instagramTestUser) in
            self?.instaGramUser?(instagramTestUser)
            DispatchQueue.main.async {
                self?.dismiss(animated: true)
            }
        }
        decisionHandler(WKNavigationActionPolicy.allow)
    }
    
}
