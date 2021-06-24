//
//  UserView.swift
//  Zodi
//
//  Created by AK on 14/09/20.
//  Copyright © 2020 Gurutechnolabs. All rights reserved.
//

import UIKit

class UserView: UIView {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var lblInfo: UILabel!
    @IBOutlet weak var imgSign: UIImageView!
    @IBOutlet weak var btnRewind: UIButton!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var imgSuperLike: UIImageView!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    private func commonInit() {
        
        Bundle.main.loadNibNamed("UserView", owner: self, options: nil)
        self.translatesAutoresizingMaskIntoConstraints = false
        contentView.frame = self.frame
        self.addSubview(contentView)
        self.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        self.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
    }

}
