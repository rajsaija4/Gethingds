//
//  EditProfileVC.swift
//  Gethingd
//
//  Created by GT-Raj on 05/07/21.
//

import UIKit
import TagListView

class EditProfileVC: UITableViewController, TagListViewDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
//    let picker = UIImagePickerController()
    @IBOutlet var img_Profile: [UIImageView]!
    @IBOutlet var img_Edit: [UIButton]!
    var selectedImage = 0
    var removeImage = 0
    
  
    @IBOutlet var img_Remove: [UIButton]!
    @IBOutlet weak var selectedPassion: TagListView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        picker.delegate = self
//        picker.allowsEditing = true
        selectedPassion.delegate = self
        selectedPassion.textFont = AppFonts.Poppins_Medium.withSize(17)
        selectedPassion.alignment = .leading
        selectedPassion.addTags(["Biking","Walking","Beauty","Golf","German Hip"])
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
//    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
//        print("Tag pressed: \(title), \(sender)")
//        tagView.isSelected = !tagView.isSelected
//    }
//
//    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
//        print("Tag Remove pressed: \(title), \(sender)")
//        sender.removeTagView(tagView)
//    }
    @IBAction func onPressRemoveProfile(_ sender: UIButton) {
        
        img_Profile[sender.tag].image = nil
        img_Edit[sender.tag].isHidden = false
        img_Remove[sender.tag].isHidden = true
     
        
        
        
        
    }
    
    @IBAction func onPressEditProfile(_ sender: UIButton) {
        if sender.tag == 0 {
            selectedImage = sender.tag
            let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
                self.openCamera()
            }))

//            alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
//                self.openGallery()
//            }))

            alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))

            self.present(alert, animated: true, completion: nil)
//
            
//
        }
           else if sender.tag == 1 {
              
                selectedImage = sender.tag
            let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
                self.openCamera()
            }))

            alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
                self.openGallery()
            }))

            alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))

            self.present(alert, animated: true, completion: nil)
        }
           else if sender.tag == 2 {
              
                selectedImage = sender.tag
            let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
                self.openCamera()
            }))

            alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
                self.openGallery()
            }))

            alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))

            self.present(alert, animated: true, completion: nil)
        }
           else if sender.tag == 3 {
              
                selectedImage = sender.tag
            let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
                self.openCamera()
            }))

            alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
                self.openGallery()
            }))

            alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))

            self.present(alert, animated: true, completion: nil)
        }
           else if sender.tag == 4 {
              
                selectedImage = sender.tag
            let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
                self.openCamera()
            }))

            alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
                self.openGallery()
            }))

            alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))

            self.present(alert, animated: true, completion: nil)
        }
           else if sender.tag == 5 {
               
                selectedImage = sender.tag
            let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
                self.openCamera()
            }))

            alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
                self.openGallery()
            }))

            alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))

            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            img_Profile[self.selectedImage].image = image
            img_Edit[self.selectedImage].isHidden = true
            img_Remove[self.selectedImage].isHidden = false
            dismiss(animated: true, completion: nil)
    }
    }
    
    @IBAction func onPressEditPassion(_ sender: UIButton) {
        let vc = TagListVC.instantiate(fromAppStoryboard: .Profile)
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
        
        
        
        
        
    }
    
    
    func openGallery()
   {
       if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
           let imagePicker = UIImagePickerController()
           imagePicker.delegate = self
           imagePicker.allowsEditing = true
           imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
           self.present(imagePicker, animated: true, completion: nil)
       }
       else
       {
           let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
           self.present(alert, animated: true, completion: nil)
       }
   }
    
    
    func openCamera()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
