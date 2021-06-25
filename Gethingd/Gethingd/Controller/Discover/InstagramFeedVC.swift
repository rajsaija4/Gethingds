//
//  InstagramFeedVC.swift
//  Zodi
//
//  Created by GT-Ashish on 19/03/21.
//  Copyright © 2021 Gurutechnolabs. All rights reserved.
//

import UIKit
import AVKit

class InstagramFeedVC: UIViewController {
    
    var arrInstaMedia: [InstaMedia] = []
    var indexPath: IndexPath = IndexPath(item: 0, section: 0)
    
    @IBOutlet weak var collectionInsta: UICollectionView!{
        didSet{
            collectionInsta.registerCell(InstaCollectionCell.self)
            collectionInsta.delegate = self
            collectionInsta.dataSource = self
            collectionInsta.backgroundColor = .black
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        collectionInsta.layoutIfNeeded()
        if indexPath.row > 0 {
            collectionInsta.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
            
        }
       
    }
 
    
    @IBAction func onBackBtnTap(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}



extension InstagramFeedVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrInstaMedia.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: InstaCollectionCell = collectionView.dequequReusableCell(for: indexPath)
        cell.backgroundColor = .black
        cell.setupInstaMedia(media: arrInstaMedia[indexPath.row])
        return cell
    }
}



extension InstagramFeedVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}



extension InstagramFeedVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        /*
        if arrInstaMedia[indexPath.row].mediaType == MediaType.CAROUSEL_ALBUM.rawValue {
            let vc: InstagramFeedVC = InstagramFeedVC.instantiate(fromAppStoryboard: .Discover)
            vc.arrInstaMedia = arrInstaMedia[indexPath.row].arrChildren
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
            return
        } else if arrInstaMedia[indexPath.row].mediaType == MediaType.VIDEO.rawValue {
            guard let videoURL = URL(string: arrInstaMedia[indexPath.row].mediaURL) else { return }
            let player = AVPlayer(url: videoURL)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            self.present(playerViewController, animated: true) {
                playerViewController.player?.play()
            }
            return
        }
        */
        
    }
}
