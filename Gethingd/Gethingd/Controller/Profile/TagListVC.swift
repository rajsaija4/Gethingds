//
//  TagListVC.swift
//  Gethingd
//
//  Created by GT-Raj on 05/07/21.
//

import UIKit
import TagListView
class TagListVC: UIViewController, TagListViewDelegate {

    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var tagViewElements: TagListView!
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.layer.cornerRadius = 15
        tagViewElements.delegate = self
        tagViewElements.textFont = AppFonts.Poppins_Medium.withSize(17)
        tagViewElements.alignment = .leading
        tagViewElements.addTags(["Biking","Walking","Beauty","Golf","German Hip Hop","Vegan","Fitness","Activism","Dog Lover","Sports","Writer","Chilling","Driving","Music","Swimming","Kisses","Laughing","Week Trips"])
//        tagViewElements.layer.cornerRadius = tagViewElements.frame.size.height/2
//        tagViewElements.addTag("On tap will be removed").onTap = { [weak self] tagView in
//            self?.tagViewElements.removeTagView(tagView)
//        }
        // Do any additional setup after loading the view.
    }
    

    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag pressed: \(title), \(sender)")
        tagView.isSelected = !tagView.isSelected
    }
    
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag Remove pressed: \(title), \(sender)")
        sender.removeTagView(tagView)
    }
 
     @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
