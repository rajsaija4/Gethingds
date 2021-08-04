//
//  ProfilePhotoCollectionCell.swift
//  Gethingd
//
//  Created by GT-Raj on 05/07/21.
//

import UIKit
import Kingfisher

class ProfilePhotoCollectionCell: UICollectionViewCell {

    @IBOutlet weak var imgProfiles: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    func setImage(string:String) {
        if let imageUrl = URL(string: string) {
            imgProfiles.kf.indicatorType = .activity
            imgProfiles.kf.indicator?.startAnimatingView()
            imgProfiles.kf.setImage(with: imageUrl, placeholder: UIImage(named: "img_profile"), options: nil, progressBlock: nil) { (_) in
             self.imgProfiles.kf.indicator?.stopAnimatingView()
         }
      }
        
        
    }

}
