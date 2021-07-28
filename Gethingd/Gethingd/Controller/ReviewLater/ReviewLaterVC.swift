//
//  ReviewLaterVC.swift
//  Gethingd
//
//  Created by GT-Ashish on 29/06/21.
//

import UIKit

class ReviewLaterVC: UIViewController {
    
    var arrUser: [UserProfile] = []
    
    
    @IBOutlet weak var collReviewLater: UICollectionView! {
        didSet {
            collReviewLater.registerCell(FreshMatchesCell.self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      getProfiles()
      

        // Do any additional setup after loading the view.
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getProfiles()

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension ReviewLaterVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrUser.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        return cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FreshMatchesCell", for: indexPath) as! FreshMatchesCell
        cell.setupReviewLater(user: arrUser[indexPath.row])
        cell.btnStatus.isHidden = true
        return cell
        
    }
    
    
}

extension ReviewLaterVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UserDetailsTVC.instantiate(fromAppStoryboard: .Discover)
        vc.user = arrUser[indexPath.row]
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    
}


extension ReviewLaterVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 40) / 3
        let height = width / 0.6
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}


extension ReviewLaterVC {
    
        
    func getProfiles(){
       
           showHUD()
           NetworkManager.Profile.getReviewLaterProfiles { (UserProfile) in
            self.arrUser.removeAll()
            self.arrUser.append(contentsOf: UserProfile)
            self.collReviewLater.reloadData()
            self.hideHUD()
        } _: { (error) in
            self.hideHUD()
            self.showToast(error)
        }

    }
}
