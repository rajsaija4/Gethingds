//
//  KolodaOverlayView.swift
//  Zodi
//
//  Created by AK on 14/09/20.
//  Copyright © 2020 Gurutechnolabs. All rights reserved.
//

import UIKit
import Koloda

//private let overlayRightImageName = "yesOverlayImage"
//private let overlayLeftImageName = "noOverlayImage"

private let overlayRightImageName = "img_like"
private let overlayLeftImageName = "img_dislike"
private let overlayUpImageName = "img_boost"
private let overlayDownImageName = "img_details"



class KolodaOverlayView: OverlayView {

    @IBOutlet lazy var overlayImageView: UIImageView! = {
        [unowned self] in
        
        var imageView = UIImageView(frame: self.bounds)
        self.addSubview(imageView)
        
        return imageView
        }()
    
    override var overlayState: SwipeResultDirection? {
        didSet {
            switch overlayState {
                case .left? :
                    overlayImageView.image = UIImage(named: overlayLeftImageName)
                case .right? :
                    overlayImageView.image = UIImage(named: overlayRightImageName)
                case .up? :
                    overlayImageView.image = UIImage(named: overlayDownImageName)
            case .down?:
                overlayImageView.image = UIImage(named: overlayUpImageName)
                default:
                    overlayImageView.image = nil
            }
        }
    }

}
