//
//  TagListVC.swift
//  Gethingd
//
//  Created by GT-Raj on 05/07/21.
//

import UIKit
import TagListView

protocol selectedPassionDelegate {
    
    func passion(passion:[ String ])
    
}

class TagListVC: UIViewController, TagListViewDelegate {
    
    var arrPassion:[String] = []
    var arrSelectedTagList:[String] = []
    var arrTagsTitle:[String] = []
  
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var tagViewElements: TagListView!
    var delegate:selectedPassionDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
//        getPassion()
//        if User.details.passion.count > 0{
//            arrSelectedTagList.append(contentsOf: User.details.passion)
//        }
        
        mainView.layer.cornerRadius = 15
        tagViewElements.delegate = self
        tagViewElements.textFont = AppFonts.Poppins_Medium.withSize(17)
        tagViewElements.alignment = .leading
        tagViewElements.addTags(arrTagsTitle)
        if arrSelectedTagList.count > 0 {
        for tagView in tagViewElements.tagViews {
            if arrSelectedTagList.contains(tagView.currentTitle ?? "") {
                tagView.isSelected = true
                arrPassion.append(tagView.currentTitle ?? "")
            }
        }
        }
//        tagViewElements.layer.cornerRadius = tagViewElements.frame.size.height/2
//        tagViewElements.addTag("On tap will be removed").onTap = { [weak self] tagView in
//            self?.tagViewElements.removeTagView(tagView)
//        }
        // Do any additional setup after loading the view.
    }
    

    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag pressed: \(title), \(sender)")
        tagView.isSelected = !tagView.isSelected
        if tagView.isSelected {
            arrPassion.append(title)
            
        }
        
        else {
            arrPassion.removeAll(where: { $0 == "\(title)"})
            }
            
        }
        
    
   
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag Remove pressed: \(title), \(sender)")
        sender.removeTagView(tagView)
    }
 
     @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
     }
    
    @IBAction func btnPressContinue(_ sender: Any) {
        delegate?.passion(passion: arrPassion)
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



