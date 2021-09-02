//
//  UIKit+Ext.swift
//
//  Created by Ashish on 20/08/20.
//  Copyright © 2020 Ashish. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView
import SafariServices
import Kingfisher

extension UIViewController {
    
    func setupNavigationBarBackBtn() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    func showHUD() {
        
       let activityData = ActivityData(size: CGSize(width: 50, height: 50),type: .ballRotateChase)
      NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        
    }
    
    func hideHUD() {
      NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
    }
    
    func openSafariViewController(_ url: URL) {
        let vc = SFSafariViewController(url: url)
        self.present(vc, animated: true)
    }
    
}

extension UIApplication {
    
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

extension UIButton {
    
    func resize() {
        titleLabel?.minimumScaleFactor = 0.5
        titleLabel?.numberOfLines = 1
        titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
}

extension UIImage {
    
    var base64StringOfImage: String {
        return self.jpegData(compressionQuality: 0.1)?.base64EncodedString() ?? ""
    }
}



extension String {
    
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    func jsonString(from object: [[String : Any]]) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    var base64Img: UIImage? {
        guard let imageData = Data(base64Encoded: self) else { return nil }
        return UIImage(data: imageData)
    }
}



extension UIColor {
    
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
}



extension Bundle {
    
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
    var releaseVersionNumberPretty: String {
        return "Version \(releaseVersionNumber ?? "1.0.0")"
    }
}



extension UIImageView {
    
    func addGradientLayer() {
        let gradient = CAGradientLayer()
        let width = SCREEN_WIDTH - 40
        let height = width * 16/11
        gradient.frame = CGRect(x: 0, y: 0, width: width, height: height)
        gradient.colors = [UIColor.clear.cgColor, UIColor.clear.cgColor ,UIColor.black.withAlphaComponent(1).cgColor]
        gradient.locations = [0, 0.5 ,1]
        self.layer.addSublayer(gradient)
    }
}



extension Notification.Name {
    
    static let changeReachability = Notification.Name("changeReachabilityNotification")
    static let receiveMessage = Notification.Name("receiveMessageNotification")
    static let recieveMatch = Notification.Name("recieveMatchNotification")
    static let recieveLike = Notification.Name("revieveLike")
    static let recieveMsg = Notification.Name("revieveLike")
    static let recieveCustom = Notification.Name("recieveCustom")
    static let removeAds = Notification.Name("updateAdsNotification")
    static let resetContent = Notification.Name("resetContentNotification")
}



extension String {
    
    var toDate: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        return dateFormatter.date(from: self)
    }
    
    var toLocalTime: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = NSTimeZone.local
        return dateFormatter.date(from: self)
    }

    var toLocal: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone.local
        return dateFormatter.date(from: self)
    }
        
    var toEventDate: String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        let date = dateFormatter.date(from: self)
        
        if let d = date {
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateFormat = "dd LLLL yyyy"
            return dateFormatter1.string(from: d).localizedUppercase
        }
        return ""
    }
    
    var toPostDate: String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        let date = dateFormatter.date(from: self)
        
        if let d = date {
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateFormat = "dd-MM-yyyy hh:mm a"
            return dateFormatter1.string(from: d)
        }
        return ""
    }
    
    var trim: String {
        return trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
    
    var toEmailFormate: String {
        if let range = range(of: "@") {
            return String(prefix(3))+"***@"+self[range.upperBound...]
        }
        return String(prefix(3))+"***@***"
    }
 
    var isValidEmail: Bool {
        let regularExpressionForEmail = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let testEmail = NSPredicate(format:"SELF MATCHES %@", regularExpressionForEmail)
        return testEmail.evaluate(with: self)
    }
    
    var isValidPhone: Bool {
        let regularExpressionForPhone = "^\\d{3}-\\d{3}-\\d{4}$"
        let testPhone = NSPredicate(format:"SELF MATCHES %@", regularExpressionForPhone)
        return testPhone.evaluate(with: self)
    }
    
    var isValidURL: Bool {
        get {
            if let url = URL(string: self) {
                return UIApplication.shared.canOpenURL(url)
            }
            return false
        }
    }
    
    var encode: String? {
        get {
            if let data = data(using: .utf8) {
                return data.base64EncodedString()
            }
            return nil
        }
    }
    
    var decode: String? {
        get {
            if let data = Data(base64Encoded: self) {
                return String(decoding: data, as: UTF8.self)
            }
            return nil
        }
    }
    
    var toURL: URL? {
        get {
            return URL(string: self)
        }
    }
}


extension UIImage {
    
    static var selectedImage: UIImage? {
        return UIImage(named: "img_select")
    }
    
    static var unSelectedImage: UIImage? {
        return UIImage(named: "img_unselect")
    }
}



extension UITextField {
    
    func setInputViewDatePicker(target: Any, selector: Selector){
        
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
        datePicker.datePickerMode = .date
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        datePicker.minimumDate = Calendar.current.date(byAdding: .year, value: -100, to: Date())
        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: -18, to: Date())
        self.inputView = datePicker
        
        
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel))
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
        toolBar.setItems([cancel, flexible, barButton], animated: false) //8
        self.inputAccessoryView = toolBar

    }
    
    @objc func tapCancel() {
        self.resignFirstResponder()
    }
    
}



extension DateFormatter {
    
    var ecmDateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        dateFormatter.timeZone = TimeZone.init(abbreviation: "IST")
        dateFormatter.locale = Locale(identifier: "IST")
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        return dateFormatter
    }
}



extension UIImageView {
    
    func setImage(_ stringURL: String) {
        guard let imgURL = URL(string: stringURL) else { return }
        self.kf.indicatorType = .activity
        self.kf.indicator?.startAnimatingView()
        self.kf.setImage(with: imgURL, completionHandler:  { (_) in
            self.kf.indicator?.stopAnimatingView()
        })
    }
}



