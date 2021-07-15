//
//  EditProfileVC.swift
//  Gethingd
//
//  Created by GT-Raj on 05/07/21.
//

import UIKit
import TagListView
import Kingfisher

class EditProfileVC: UITableViewController, TagListViewDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate, selectedPassionDelegate {
    
//    let picker = UIImagePickerController()
    func passion(passion: [String]) {
        arrPassion.removeAll()
//        selectedPassion.isHidden = true
        arrPassion.append(contentsOf: passion)
        selectedPassion.textFont = AppFonts.Poppins_Medium.withSize(17)
        selectedPassion.alignment = .leading
        selectedPassion.addTags(arrPassion)
        
    }
  
    @IBOutlet var btnGender: [UIButton]!
    @IBOutlet weak var txtNumberOfKids: CustomTextField!
    @IBOutlet weak var collKid: UICollectionView! {
        didSet{
            collKid.registerCell(KidCell.self)
            collKid.dataSource = self
            collKid.delegate = self
        }
    }
    @IBOutlet weak var txtJobTitle: UITextField!
    @IBOutlet weak var lblWordCounter: UILabel!
    @IBOutlet weak var txtAbout: UITextView!
    @IBOutlet weak var txtDob: CustomTextField!
    @IBOutlet weak var txtFname: CustomTextField!
    @IBOutlet weak var txtLname: CustomTextField!
    @IBOutlet var img_Profile: [UIImageView]!
    @IBOutlet var img_Edit: [UIButton]!
    var selectedImage = 0
    var selectedGender = -1
    var removeImage = 0
    fileprivate var arrPassion:[String] = []

    fileprivate let placeHolder = "About Information"
    fileprivate var arrKids = [Int: String]()
//    fileprivate var arrkidsValue:[String] = []
    fileprivate var numberOfKids = 0
    
    
  
    @IBOutlet var img_Remove: [UIButton]!
    @IBOutlet weak var selectedPassion: TagListView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        navigationController?.navigationBar.isHidden = true
//        getProfile()
//        txtNumberOfKids.setPlaceHolderColor()
        selectedPassion.delegate = self
        selectedPassion.textFont = AppFonts.Poppins_Medium.withSize(17)
        selectedPassion.alignment = .leading
//        selectedPassion.addTags(["Biking","Walking","Beauty","Golf","German Hip"])
  
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
  
    }
    
    @IBAction func onPressbackBtn(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onPressGenderbtn(_ sender: UIButton) {
        
        for btn in btnGender {
            if btn.tag == sender.tag {
                btn.isSelected = true
                selectedGender = btn.tag
            } else {
                btn.isSelected = false
            }
        }
        
    }
    
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
        vc.delegate = self
        vc.arrSelectedTagList.removeAll()
        vc.arrSelectedTagList.append(contentsOf: arrPassion)
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
   
    @IBAction func onPressChild(_ sender: UIControl) {
        
        let keys = Array(arrKids.keys).sorted(by: <).map{ $0.description }
        
        let alert = UIAlertController(title: "No of Kids", message: "Selct No of Kids", actionNames: keys) { (action) in

            self.txtNumberOfKids.text = action.title ?? ""
            
            self.numberOfKids = Int(action.title ?? "0") ?? 0
            
            guard let count = Int(action.title ?? "0"), count > 0 else {
                
                self.tableView.reloadData()
                self.tableView.invalidateIntrinsicContentSize()
                self.tableView.layoutIfNeeded()
                self.collKid.reloadData()
                self.collKid.invalidateIntrinsicContentSize()
                self.collKid.layoutIfNeeded()
                
                return
            }

            self.tableView.reloadData()
            self.tableView.invalidateIntrinsicContentSize()
            self.tableView.layoutIfNeeded()
            self.collKid.reloadData()
            self.collKid.invalidateIntrinsicContentSize()
            self.collKid.layoutIfNeeded()
            
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func onKidTypeTap(_ sender: UIControl) {
        
        let alert = UIAlertController(title: "Choose Kid Type", message: "", actionNames: ["New born", "Infant"]) { (action) in
            self.arrKids[sender.tag] = action.title ?? ""
            self.collKid.reloadData()
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    
}
    
  


extension EditProfileVC {
    
    
}

extension EditProfileVC {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 448
        }

        if indexPath.section == 1 {
            return 400
            
            
        }

        if indexPath.section == 2 {
            return CGFloat((numberOfKids * 50) + 74)
        }
        
        if indexPath.section == 3 {
            return 200
        }

        if indexPath.section == 4 {
            return 100
            
           
        }

        if indexPath.section == 5 {
            return 100
        }
        return UITableView.automaticDimension
    }
}


extension EditProfileVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrKids.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: KidCell = collectionView.dequequReusableCell(for: indexPath)
        cell.lblKid.text = "\(indexPath.row + 1)"
        cell.lblKidType.text = self.arrKids[indexPath.row]
        cell.kidTypeControl.tag = indexPath.row
        cell.kidTypeControl.addTarget(self, action: #selector(onKidTypeTap(_:)), for: .touchUpInside)
        return cell
    }
}

extension EditProfileVC: UICollectionViewDelegate {
    
    
}

extension EditProfileVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

extension EditProfileVC {
    
    fileprivate func setupUI() {
        
        getProfile()
        
//        navigationItem.setHidesBackButton(true, animated: true)
        
//        txtDate.setInputViewDatePicker(target: self, selector: #selector(self.onDoneBtnTap))
        
        for i in 0..<arrKids.count {
            self.arrKids[i] = "New born"
        }
        
    }
    
    fileprivate func getProfile() {
        showHUD()
        NetworkManager.Profile.getMyProfile { (profile) in
            if let url = URL(string: User.details.image1) {
                self.img_Profile[0].kf.setImage(with: url)
                self.img_Edit[0].isHidden = true
                self.img_Remove[0].isHidden = false
            }
            
            if let url = URL(string: User.details.image2) {
                self.img_Profile[1].kf.setImage(with: url)
                self.img_Edit[1].isHidden = true
                self.img_Remove[1].isHidden = false
            }
            
            if let url = URL(string: User.details.image3) {
                self.img_Profile[2].kf.setImage(with: url)
                self.img_Edit[2].isHidden = true
                self.img_Remove[2].isHidden = false
            }
            
            if let url = URL(string: User.details.image4) {
                self.img_Profile[3].kf.setImage(with: url)
                self.img_Edit[3].isHidden = true
                self.img_Remove[3].isHidden = false
            }
            
            if let url = URL(string: User.details.image5) {
                self.img_Profile[4].kf.setImage(with: url)
                self.img_Edit[4].isHidden = true
                self.img_Remove[4].isHidden = false
            }
            
            if let url = URL(string: User.details.image6) {
                self.img_Profile[5].kf.setImage(with: url)
                self.img_Edit[5].isHidden = true
                self.img_Remove[5].isHidden = false
            }
            self.arrPassion.removeAll()
            self.arrPassion.append(contentsOf: User.details.passion)
            self.selectedPassion.addTags(self.arrPassion)
            
            self.txtFname.text = User.details.firstName
            self.txtLname.text = User.details.lastName
            self.txtDob.text = User.details.dob
            self.txtAbout.text = User.details.about
            self.txtJobTitle.text = User.details.job_title
            self.txtNumberOfKids.text = String(User.details.num_of_kids)
            self.numberOfKids = User.details.num_of_kids
            if User.details.gender == "male" {
                self.btnGender[0].isSelected = true
                
            }
            else if User.details.gender == "female" {
                self.btnGender[1].isSelected = true
                
            }
            else {
                self.btnGender[2].isSelected = true
            }
            
            let count = User.details.user_kids.count
            for i in User.details.user_kids {
                for index in 0...count - 1{
                    self.arrKids[index] = i
                }
            }
            print(self.arrKids)
            self.collKid.reloadData()
//            self.tableView.reloadData()
        
            
            
            self.hideHUD()
        } _: { (error) in
            self.hideHUD()
            print(error)
        }

    }

    
    
}
extension EditProfileVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if txtAbout.text == placeHolder {
            txtAbout.text = nil
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if txtAbout.text.isEmpty {
            txtAbout.text = placeHolder
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        lblWordCounter.text = "Characters left: \(150 - txtAbout.text.count)"
        return txtAbout.text.count < 150
    }
    
}
