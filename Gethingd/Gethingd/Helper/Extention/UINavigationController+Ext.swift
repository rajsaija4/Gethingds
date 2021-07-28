//
//  UINavigationController+Ext.swift
//  Zodi
//
//  Created by AK on 11/09/20.
//  Copyright © 2020 Gurutechnolabs. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {
    
    func addBackButtonWithTitle(title: String? = nil, action: Selector? = nil, imgUser: (imgURLString: String, imgAction: Selector)? = nil, reportAction: Selector? = nil) {
        
        for view in navigationBar.subviews {
            view.removeFromSuperview()
        }
        
//        let top: CGFloat = self.view.safeAreaInsets.top
//        let offset : CGFloat = top == 0 ? self.presentingViewController?.view.safeAreaInsets.top ?? 0 : self.view.safeAreaInsets.top
//
//        let shadowView = UIView(frame: CGRect(x: 0, y: -offset,
//                                              width: self.navigationBar.bounds.width,
//                                              height: self.navigationBar.bounds.height + offset))
//
//        shadowView.backgroundColor = .groupTableViewBackground
//        self.navigationBar.insertSubview(shadowView, at: 1)
//
//        shadowView.layer.insertSublayer(shadowLayer(shadowView: shadowView), at: 0)
        
        
        let view = self.navigationBar
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.tag = -1
        self.navigationBar.insertSubview(stackView, at: 1)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8).isActive = true
        
        if let actionBtn = action {
            stackView.addArrangedSubview(backButton(action: actionBtn))
        }
        
        if let userImage = imgUser {
            stackView.addArrangedSubview(customButton(action: userImage.imgAction, imgURLString: userImage.imgURLString))
        }
        
        if let name = title {
            
            stackView.addArrangedSubview(titleLable(name))
        }
        
        if let newReportAction = reportAction {
            stackView.addArrangedSubview(reportButton(action: newReportAction))
        }
        
    }
    
    
    /*
    func addBackButtonWithTitle(title: String? = nil, action: Selector? = nil, imgAction: Selector? = nil) {
        
        for view in navigationBar.subviews {
            view.removeFromSuperview()
        }
        
    
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        
        guard let shadowView = navigationBar.subviews.first(where: { $0.tag == -1 }) else {
            
            let top: CGFloat = self.view.safeAreaInsets.top
            let offset : CGFloat = top == 0 ? self.presentingViewController?.view.safeAreaInsets.top ?? 0 : self.view.safeAreaInsets.top
            
            let shadowView = UIView(frame: CGRect(x: 0, y: -offset,
                                                  width: self.navigationBar.bounds.width,
                                                  height: self.navigationBar.bounds.height + offset))
            
            shadowView.tag = -1
            shadowView.backgroundColor = .groupTableViewBackground
            self.navigationBar.insertSubview(shadowView, at: 1)
            
            shadowView.layer.insertSublayer(shadowLayer(shadowView: shadowView), at: 0)
            
            let stackView = addStackView(shadowView: shadowView)
            
            if let actionBtn = action {
                stackView.addArrangedSubview(backButton(action: actionBtn))
            }
            
            if let name = title {
                
                stackView.addArrangedSubview(titleLable(name))
            }
            
            
            return
        }
        
        if let stackView = shadowView.subviews.first(where: { $0.tag == -1 }) as? UIStackView {
            
            if let backBtn = stackView.arrangedSubviews.first(where: { $0.tag == -2 }) as? UIButton {
                if let actionBtn = action {
                    backBtn.addTarget(self.topViewController, action: actionBtn, for: .touchUpInside)
                } else {
                    backBtn.removeFromSuperview()
                }
            } else {
                if let actionBtn = action {
                    stackView.insertArrangedSubview(backButton(action: actionBtn), at: 0)
                }
            }
            
            if let titleLbl = stackView.arrangedSubviews.first(where: { $0.tag == -1 }) as? UILabel {
                if let name = title {
                    
                    titleLbl.text = name
                } else {
                    titleLbl.removeFromSuperview()
                }
            } else {
                if let name = title {
                    
                    stackView.addArrangedSubview(titleLable(name))
                }
            }
            
            
        } else {
            let stackView = addStackView(shadowView: shadowView)
            
            if let actionBtn = action {
                stackView.addArrangedSubview(backButton(action: actionBtn))
            }
            
            if let name = title {
                
                stackView.addArrangedSubview(titleLable(name))
            }
        }
  
    }
 
    */
    
    fileprivate func shadowLayer(shadowView: UIView) -> CAShapeLayer {
        let shadowLayer = CAShapeLayer()
        shadowLayer.path = UIBezierPath(roundedRect: shadowView.bounds, byRoundingCorners: [.bottomRight], cornerRadii: CGSize(width: 50, height: 50)).cgPath
        
        shadowLayer.fillColor = COLOR.App.cgColor
        return shadowLayer
    }
    
    fileprivate func addStackView(shadowView: UIView) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.tag = -1
        shadowView.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor, constant: 16).isActive = true
        stackView.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor, constant: -16).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        stackView.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor, constant: -8).isActive = true
        return stackView
    }
    
    fileprivate func titleLable(_ name: String) -> UILabel {
        let titleLabel = UILabel()
        titleLabel.tag = -1
        titleLabel.text = name
        titleLabel.font = AppFonts.Poppins_Medium.withSize(17)
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.numberOfLines = 1
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textColor = COLOR.Black
        return titleLabel
    }
    
    fileprivate func customButton(action: Selector, imgURLString: String) -> UIButton {
        let btnCustom = UIButton(type: .custom)
        btnCustom.imageView?.contentMode = .scaleAspectFill
        if let imgURL = URL(string: imgURLString) {
            btnCustom.kf.setImage(with: imgURL, for: .normal)
        } else {
            btnCustom.setImage(UIImage(named: "img_user"), for: .normal)
        }
    
        btnCustom.cornerRadius = 15
        btnCustom.clipsToBounds = true
        btnCustom.addTarget(self.topViewController, action: action, for: .touchUpInside)
        btnCustom.translatesAutoresizingMaskIntoConstraints = false
        btnCustom.widthAnchor.constraint(equalToConstant: 30).isActive = true
        btnCustom.heightAnchor.constraint(equalToConstant: 30).isActive = true
        return btnCustom
    }
    
    fileprivate func reportButton(action: Selector) -> UIButton {
        let btnCustom = UIButton(type: .custom)
        btnCustom.setImage(UIImage(named: "img_Report"), for: .normal)
        btnCustom.addTarget(self.topViewController, action: action, for: .touchUpInside)
        btnCustom.translatesAutoresizingMaskIntoConstraints = false
        btnCustom.widthAnchor.constraint(equalToConstant: 30).isActive = true
        btnCustom.heightAnchor.constraint(equalToConstant: 30).isActive = true
        return btnCustom
    }
    
    
    
    fileprivate func backButton(action: Selector) -> UIButton {
        let btnBack = UIButton(type: .custom)
        btnBack.setImage(UIImage(named: "img_back"), for: .normal)
        btnBack.tintColor = .white
        btnBack.tag = -2
        btnBack.addTarget(self.topViewController, action: action, for: .touchUpInside)
        btnBack.translatesAutoresizingMaskIntoConstraints = false
        btnBack.widthAnchor.constraint(equalToConstant: 30).isActive = true
        btnBack.heightAnchor.constraint(equalToConstant: 30).isActive = true
        return btnBack
    }
}
