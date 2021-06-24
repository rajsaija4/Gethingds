//
//  UIAlertController+Extension.swift
//
//  Created by Ashish on 20/08/20.
//  Copyright © 2020 Ashish. All rights reserved.
//

import Foundation
import UIKit


extension UIAlertController {
    
    convenience init(title: String, message: String) {
        self.init(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        self.addAction(okAction)
    }
    
    convenience init(netErrorTitle: String) {
        
        self.init(title: netErrorTitle, message: "Internet not available, please check your internet connectivity and try again", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        self.addAction(okAction)
    }
    
    convenience init(title: String, message: String, handler: @escaping(UIAlertAction) -> Void) {
        
        self.init(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (actionOther) in
            handler(actionOther)
        }
        self.addAction(okAction)
        
    }
    
    convenience init(title: String, message: String, actionName: String, handler: @escaping(UIAlertAction) -> Void) {
        
        self.init(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        self.addAction(cancelAction)
        
        let otherAction = UIAlertAction(title: actionName, style: .default) { (actionOther) in
            handler(actionOther)
        }
        self.addAction(otherAction)
    }
    
    convenience init(title: String, message: String, actionNames: [String], handler: @escaping(UIAlertAction) -> Void) {
        
        self.init(title: title, message: message, preferredStyle: .actionSheet)
        
        for i in 0..<actionNames.count {
            
            let otherAction = UIAlertAction(title: actionNames[i], style: .default) { (actionOther) in
                handler(actionOther)
            }
            otherAction.accessibilityLabel = actionNames[i]
            self.addAction(otherAction)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        self.addAction(cancelAction)
    }
    
    convenience init(title: String, message: String, actionName: String, placeholder: String, handler: @escaping(UITextField) -> Void) {
        
        self.init(title: title, message: message, preferredStyle: .alert)
        
        self.addTextField { (textField) in
            textField.placeholder = placeholder
            textField.keyboardType = .numberPad
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        self.addAction(cancelAction)
        
        let otherAction = UIAlertAction(title: actionName, style: .default) { (actionOther) in
            let textField = self.textFields?.first
            handler(textField!)
        }
        self.addAction(otherAction)
    }
    
    convenience init(loginError: String) {
        self.init(title: loginError, message: "The email address or password you entered is incorrect", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        self.addAction(okAction)
    }
}
