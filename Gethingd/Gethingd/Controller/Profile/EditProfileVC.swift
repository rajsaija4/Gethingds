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
        arrPassion.append(contentsOf: passion)
        selectedPassion.textFont = AppFonts.Poppins_Medium.withSize(17)
        selectedPassion.alignment = .leading
        selectedPassion.removeAllTags()
        selectedPassion.addTags(arrPassion)
        tableView.reloadData()
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
    @IBOutlet var arrLookingforBtn: [UIButton]!
    @IBOutlet weak var txtLname: CustomTextField!
    @IBOutlet weak var txtEmail: CustomTextField!
    @IBOutlet var img_Profile: [UIImageView]!
    @IBOutlet var img_Edit: [UIButton]!
    var selectedImage = 0
     var selectedLookingFor = -1
    var selectedGender = -1
    var isFromLogin = false
    var onPopView: (() -> Void)?
    var removeImage = 0
    var arrTags:[TagList] = []
    fileprivate var arrPassion:[String] = []

    fileprivate let placeHolder = "About Information"
    fileprivate var arrKids = [Int: String]()
//    fileprivate var arrkidsValue:[String] = []
    fileprivate var numberOfKids = 0
    fileprivate var passionSetting: PassionSetting? = nil
    
    
  
    @IBOutlet var img_Remove: [UIButton]!
    @IBOutlet weak var selectedPassion: TagListView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        txtFname.setPlaceHolderColor()
        txtLname.setPlaceHolderColor()
        txtDob.setPlaceHolderColor()
//        txtEmail.setPlaceHolderColor()
        txtNumberOfKids.setPlaceHolderColor()
        txtAbout.delegate = self
        setupUI()
        navigationController?.navigationBar.isHidden = true
//        getProfile()
//        txtNumberOfKids.setPlaceHolderColor()
        selectedPassion.delegate = self
        selectedPassion.textFont = AppFonts.Poppins_Medium.withSize(17)
        selectedPassion.alignment = .leading
        selectedPassion.backgroundColor = .clear
        
//        selectedPassion.addTags(["Biking","Walking","Beauty","Golf","German Hip"])
  
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
  
    }
    
    
    @IBAction func onLookingForbtnTap(_ sender: UIButton) {
        
        for btn in arrLookingforBtn {
            if btn.tag == sender.tag {
                btn.isSelected = true
                selectedLookingFor = btn.tag
            } else {
                btn.isSelected = false
            }
        }
    }
    
    @IBAction func onPressUpdatebtnTap(_ sender: UIButton) {
        
        let img1 = img_Profile[0].image
        let img2 = img_Profile[1].image
        let img3 = img_Profile[2].image
        let img4 = img_Profile[3].image
        let img5 = img_Profile[4].image
        let img6 = img_Profile[5].image
        
        let imgData1 = img1?.jpegData(compressionQuality: 0.5)
        let imgData2 = img2?.jpegData(compressionQuality: 0.5)
        let imgData3 = img3?.jpegData(compressionQuality: 0.5)
        let imgData4 = img4?.jpegData(compressionQuality: 0.5)
        let imgData5 = img5?.jpegData(compressionQuality: 0.5)
        let imgData6 = img6?.jpegData(compressionQuality: 0.5)
        
        var source: [String: Data] = [:]
        
        if imgData1 != nil {
            source.merge(["image1": imgData1!]) { (current, _) -> Data in
                return current
            }
        }
        
        if imgData2 != nil {
            source.merge(["image2": imgData2!]) { (current, _) -> Data in
                return current
            }
        }
        
        if imgData3 != nil {
            source.merge(["image3": imgData3!]) { (current, _) -> Data in
                return current
            }
        }
        
        if imgData4 != nil {
            source.merge(["image4": imgData4!]) { (current, _) -> Data in
                return current
            }
        }
        
        if imgData5 != nil {
            source.merge(["image5": imgData5!]) { (current, _) -> Data in
                return current
            }
        }
        
        if imgData6 != nil {
            source.merge(["image6": imgData6!]) { (current, _) -> Data in
                return current
            }
        }
        
        guard source.count > 0 else {
            self.showAlert("Please upload at least one picture")
            return
        }
        
        
        guard selectedLookingFor  >= 0  else {
            self.showAlert("Please Select Looking For")
            return
        }
        var lookingForPass = ""

        if selectedLookingFor == 0 {
                lookingForPass = "Male"
        }

        if selectedLookingFor == 1 {
            lookingForPass = "Female"
        }

        if selectedLookingFor == 2 {
            lookingForPass = "Both"
        }
        
        
        //        guard let img1 = arrImageProfile[0].image, let img2 = arrImageProfile[1].image, let img3 = arrImageProfile[2].image, let img4 = arrImageProfile[3].image, let img5 = arrImageProfile[4].image else {
        //            self.showAlert("Please Select All Profile Image")
        //            return
        //        }
        
        
        
        guard let firstName = txtFname.text, firstName.count > 0 else {
            self.showAlert("Please \(txtFname.placeholder ?? "")")
            return
        }
        
        guard let lastName = txtLname.text, lastName.count > 0 else {
            self.showAlert("Please \(txtLname.placeholder ?? "")")
            return
        }
        
       
        
        guard let dob = txtDob.text, dob.count > 0 else {
            self.showAlert("Please Select Date Of Birth")
            return
        }
        
//        guard let email = txtEmail.text, email.count > 0, email != placeHolder else {
//            self.showAlert("Please Enter Email")
//            return
//        }
        
        guard let noOfkids = txtNumberOfKids.text, noOfkids.count > 0 else {
            self.showAlert("Please Enter No of Kids")
            return
        }
        
        
//        guard email.isValidEmail else {
//            self.showAlert("Please Enter Valid Email")
//            return
//        }
        
        
        let kids:[String] = collKid.visibleCells.map{ ($0 as? KidCell)?.lblKidType.text ?? "" }
        

        guard selectedGender  >= 0  else {
            self.showAlert("Please Select Gender")
            return
        }
        
        var gendertoPass = ""

        if selectedGender == 0 {
                gendertoPass = "male"
        }

         if selectedGender == 1 {
            gendertoPass = "female"
        }

        if selectedGender == 2 {
            gendertoPass = "other"
        }

        
          
        var arrPassionIds = [String]()
        
        for passion in arrPassion {
            if let id = self.arrTags.first(where: {$0.passion == passion})?.id {
                arrPassionIds.append("\(id)")
            }
        }
        
        
        
        let parameters =
            [
                "first_name": firstName,
                "last_name": lastName,
                "dob": dob,
                "job_title":txtJobTitle.text ?? "",
                "about": txtAbout.text ?? "",
                "kids":kids.joined(separator: ","),
                "num_of_kids": noOfkids,
                "gender": gendertoPass,
                "passion":arrPassionIds.joined(separator: ","),
                "looking_for":lookingForPass

            ] as [String : String]



        addProfile(source: source, parameters: parameters)
        
    }
    
    
        fileprivate func addProfile(source: [String: Data], parameters: [String: String]) {
            showHUD()
            NetworkManager.Profile.addProfile(source: source, params: parameters, { (message) in
                self.hideHUD()
                
//                if User.details.email_verified == 0
//                {
//                self.showVerifyEmailAlert()
//                    return
//                }
                
                
    //                        self.showAlert(message)
                
                let alert = UIAlertController(title: "Success", message: message) { (_) in
                    if self.isFromLogin {
                        APPDEL?.setupMainTabBarController()
                    } else {
                        self.onPopView?()
                        self.navigationController?.popViewController(animated: false)
                    }
                }
                self.present(alert, animated: true, completion: nil)
                
                
            }) { (error) in
                self.hideHUD()
                self.showAlert(error)
            }
        }
    
    fileprivate func verifyEmailOTP(param: [String: Any]) {
        
        showHUD()
        NetworkManager.Auth.verifyEmail(param: param, { (success) in
            self.hideHUD()
            APPDEL?.setupMainTabBarController()
            
        }) { (error) in
            self.hideHUD()
            self.showAlert(error)
        }
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
        vc.delegate = self
        for i in arrTags {
            vc.arrTagsTitle.append(i.passion)
        }
        if arrPassion.count > 0 {
            vc.arrSelectedTagList.removeAll()
            vc.arrSelectedTagList.append(contentsOf: arrPassion)
        }
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
        
        let alert = UIAlertController(title: "Choose Kid Type", message: "", actionNames: ["New born", "Infant","Toddler","Preschooler","School-aged child","Adolescent"]) { (action) in
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
            return 400
            
        }

        if indexPath.section == 1 {
            return 400
            
            
        }

        if indexPath.section == 2 {
            return CGFloat((numberOfKids * 50) + 74)
           
        }
        
        if indexPath.section == 3 {
            return CGFloat(selectedPassion.subviews.count * 48) + 60
        }

        if indexPath.section == 4 {
            return 92
            
           
        }

        if indexPath.section == 5 {
            return 100
        }
        
        if indexPath.section == 6 {
            return 100
        }
        return UITableView.automaticDimension
    }
}


extension EditProfileVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfKids
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
        
        
        getPassion()
        
//        navigationItem.setHidesBackButton(true, animated: true)
        
        txtDob.setInputViewDatePicker(target: self, selector: #selector(self.onDoneBtnTap))
        
//        for i in 0..<arrKids.count {
//            self.arrKids[i] = "New born"
//        }
        
    }
    
    @objc fileprivate func onDoneBtnTap() {
        
        if let datePicker = txtDob.inputView as? UIDatePicker, txtDob.isFirstResponder {
            txtDob.text = DateFormatter().ecmDateFormatter.string(from: datePicker.date)
            txtDob.resignFirstResponder()
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
            for id in User.details.passion {
                if let pas = self.arrTags.first(where: {$0.id == Int(id)})?.passion {
                    self.arrPassion.append(pas)
                }
                
            }
            print(self.arrPassion)
            for i in self.arrPassion {
                self.selectedPassion.addTag(i)
            }
          
//            self.txtEmail.text = User.details.email
            self.txtFname.text = User.details.firstName
            var lookfor = User.details.looking_for
            print(lookfor)
            if lookfor == "male" {
                self.arrLookingforBtn[0].isSelected = true
            }
            
            if lookfor == "female"{
                self.arrLookingforBtn[1].isSelected = true
            }
            
            if  lookfor == "both" {
                self.arrLookingforBtn[2].isSelected = true
            }
            
            self.txtLname.text = User.details.lastName
            self.txtJobTitle.text = User.details.job_title
            self.txtDob.text = User.details.dob
            self.numberOfKids = User.details.num_of_kids
            if User.details.about.count > 0 {
            self.txtAbout.text = User.details.about
            }
            if User.details.about.count > 0 {
               
                self.txtAbout.textColor = UIColor.black
              
            }
            self.lblWordCounter.text = "Characters left: \(150 - self.txtAbout.text.count)"
            self.txtNumberOfKids.text = String(User.details.num_of_kids)
            
            if User.details.gender == "male" {
                self.btnGender[0].isSelected = true
                self.selectedGender = 0
                
            }
            else if User.details.gender == "female" {
                self.btnGender[1].isSelected = true
                self.selectedGender = 1
                
            }
            else {
                self.btnGender[2].isSelected = true
                self.selectedGender = 2
            }
            
            if let kidsCount = self.passionSetting?.noKids {
                for i in 0...kidsCount {
                    if i < User.details.user_kids.count {
                        self.arrKids[i] = User.details.user_kids[i]
                    }
                    
                }
            }
        
           
            self.collKid.reloadData()
            self.tableView.reloadData()
        
            
            
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
            txtAbout.textColor = UIColor(hexString: "#4C4C4C")
            txtAbout.text = placeHolder
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        txtAbout.textColor = .black
        lblWordCounter.text = "Characters left: \(150 - txtAbout.text.count)"
        return txtAbout.text.count < 150
    }
    
    
    fileprivate func getPassion() {
         showHUD()
         NetworkManager.getPassion { (PassionSetting) in
             self.arrTags.append(contentsOf: PassionSetting.passion)
             print(self.arrTags)
             self.hideHUD()
             for i in 0...PassionSetting.noKids {
                 self.arrKids[i] = "New born"
             }
            self.passionSetting = PassionSetting
             self.collKid.reloadData()
            self.getProfile()
         } _: { (error) in
             self.hideHUD()
             self.showToast(error)
         }

     }
}
extension EditProfileVC {
    
    func showAlert(_ alert: String) {
        let alert = UIAlertController(title: "Oops!", message: alert)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    fileprivate func showVerifyEmailAlert() {
        guard let email = self.txtEmail.text else { return }
        let alert = UIAlertController(title: "Email OTP Verification", message: "Please enter the code received in your email \(email). If you do not see email in your Inbox then please check your Spam/Junk emails.", actionName: "Verify", placeholder: "Enter Verification OTP") { (txtOTP) in
            
            let param = [
                "email": email,
                "otp": txtOTP.text ?? ""
            ]
            self.verifyEmailOTP(param: param)
        }
        self.present(alert, animated: true, completion: nil)
    }
}
