//
//  SignCell.swift
//  Zodi
//
//  Created by AK on 10/09/20.
//  Copyright © 2020 Gurutechnolabs. All rights reserved.
//

import UIKit

class SignCell: UICollectionViewCell {
    
    
    //MARK:- VARIABLE
    
    //MARK:- OUTLET
    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak var imgSign: UIImageView!
    @IBOutlet weak var lblSignName: UILabel!
    @IBOutlet weak var btnLock: UIButton!
    
    //MARK:- LIFECYCLE

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupProfileCell(name: String) {
        
        if let url = URL(string: name.getSignURL) {
            imgSign.kf.setImage(with: url)
        }
        btnCheck.isSelected = false
        lblSignName.text = name.signName
        lblSignName.textColor = .lightGray
    }
    
    func setupProfileCellSelected(name: String) {
        
        if let url = URL(string: name.getActiveSignURL) {
            imgSign.kf.setImage(with: url)
        }
        btnCheck.isSelected = true
        lblSignName.text = name.signName
        lblSignName.textColor = COLOR.App
    }
    
    func setupFilterCell(name: String) {
        if let url = URL(string: name.getSignURL) {
            imgSign.kf.setImage(with: url)
        }
        btnCheck.isSelected = false
        lblSignName.text = name.signName
        lblSignName.textColor = .lightGray
    }
    
    func setupFilterCellSelected(name: String) {
        
        if let url = URL(string: name.getActiveSignURL) {
            imgSign.kf.setImage(with: url)
        }
        btnCheck.isSelected = true
        lblSignName.text = name.signName
        lblSignName.textColor = COLOR.App
    }

}
