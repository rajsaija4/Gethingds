//
//  InstaCollectionCell.swift
//  Zodi
//
//  Created by GT-Ashish on 19/03/21.
//  Copyright © 2021 Gurutechnolabs. All rights reserved.
//

import UIKit

class InstaCollectionCell: UICollectionViewCell {

    @IBOutlet weak var imgInsta: UIImageView!
    @IBOutlet weak var lblMediaCount: UILabel!
    @IBOutlet weak var imgPlay: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    func setupInstaMedia(media: InstaMedia) {
        let imageURL = (media.mediaType == MediaType.IMAGE.rawValue || media.mediaType == MediaType.CAROUSEL_ALBUM.rawValue) ? media.mediaURL : media.thumbnailURL
        imgInsta.setImage(imageURL)
        lblMediaCount.isHidden = true
//        lblMediaCount.isHidden = media.arrChildren.count == 0
//        lblMediaCount.text = "\(media.arrChildren.count)"
        imgPlay.isHidden = true
//        imgPlay.isHidden = !(media.mediaType == MediaType.VIDEO.rawValue)
    }

}
