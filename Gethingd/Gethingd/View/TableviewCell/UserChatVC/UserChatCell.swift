//
//  UserChatCell.swift
//  Zodi
//
//  Created by AK on 16/09/20.
//  Copyright © 2020 Gurutechnolabs. All rights reserved.
//

import UIKit


class UserChatCell: UITableViewCell {

    @IBOutlet weak var btnStatus: UIButton!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblLastMsg: UILabel!
    @IBOutlet weak var lblTIime: UILabel!
    @IBOutlet weak var lblUnread: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblUnread.clipsToBounds = true
        lblUnread.layer.cornerRadius = self.lblUnread.bounds.width / 2
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(user: ChatMessages) {
//        if let imgURL = URL(string: user.userImage) {
//            imgUser.kf.setImage(with: imgURL)
//        }
        if let imageUrl = URL(string: user.userImage) {
        imgUser.kf.indicatorType = .activity
        imgUser.kf.indicator?.startAnimatingView()
            imgUser.kf.setImage(with: imageUrl, placeholder: UIImage(named: "img_profile"), options: nil, progressBlock: nil) { (_) in
            self.imgUser.kf.indicator?.stopAnimatingView()
        }
     }
        lblName.text = user.userName
        lblLastMsg.text = user.message
        lblTIime.text = user.createAt.displayTime
        lblUnread.isHidden = user.unreadMessageCount == 0
        lblUnread.text = "\(user.unreadMessageCount)"
        if Date().timeIntervalSince1970 - user.lastSeen >= 120 {
            btnStatus.isSelected = false
        }
        else{
            btnStatus.isSelected = true
        }
    }
    
}


extension String
{
    var convertFromUTCtoLocal: Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        let convertedDate = formatter.date(from: self)
        formatter.timeZone = TimeZone(secondsFromGMT: TimeZone.current.secondsFromGMT())
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let strLocal = formatter.string(from: convertedDate!)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter.date(from: strLocal) ?? Date()
    }
    
    var convertFromLocaltoCurrentFormatDateForNotification: Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.timeZone = TimeZone.init(abbreviation: "UTC")
        formatter.locale = Locale(identifier: "UTC")
        formatter.calendar = Calendar(identifier: .gregorian)
        let localDate = formatter.date(from: self) ?? Date()
        formatter.timeZone = TimeZone.current
        let strDate = formatter.string(from: localDate)
        return formatter.date(from: strDate) ?? Date()
    }
    
    var convertFromLocaltoCurrentFormatStringDateForNotification: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone.init(abbreviation: "UTC")
        formatter.locale = Locale(identifier: "UTC")
        formatter.calendar = Calendar(identifier: .gregorian)
        let localDate = formatter.date(from: self) ?? Date()
        formatter.timeZone = TimeZone.current
        let strDate = formatter.string(from: localDate)
        return strDate
    }
    
    
    
    var convertFromLocaltoUTC: Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        return formatter.date(from: self) ?? Date()
    }
    
    var displayTime: String {
        let currentDate = Date()
        
        let timeZoneDate = self.convertFromLocaltoCurrentFormatDateForNotification
        
        if (currentDate).weeks(from: timeZoneDate) > 0 {
            
            if (currentDate).weeks(from: timeZoneDate) > 1 {
//                return self.convertFromLocaltoCurrentFormatStringDateForNotification
                return "\(currentDate.days(from: timeZoneDate)) days"
            }
            
            return "\(currentDate.weeks(from: timeZoneDate)) week"
        } else if currentDate.days(from: timeZoneDate) > 0 {
            return "\(currentDate.days(from: timeZoneDate))" + (currentDate.days(from: timeZoneDate) == 1 ? " day" : " days")
        } else if currentDate.hours(from: timeZoneDate) > 0 {
            return "\(currentDate.hours(from: timeZoneDate)) hour"
        } else if currentDate.minutes(from: timeZoneDate) > 0 {
            return "\(currentDate.minutes(from: timeZoneDate)) minute"
        } else {
            return "just"
        }
    }
    
    
}

extension Date {
    
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfYear], from: date, to: self).weekOfYear ?? 0
    }
    
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
}
