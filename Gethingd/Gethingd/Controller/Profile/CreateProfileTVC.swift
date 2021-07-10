//
//  CreateProfileTVC.swift
//  Zodi
//
//  Created by AK on 10/09/20.
//  Copyright © 2020 Gurutechnolabs. All rights reserved.
//

import UIKit
import GooglePlaces
import SwiftyJSON
import CoreLocation
import CropViewController
import TagListView

class CreateProfileTVC: UITableViewController, UIImagePickerControllerDelegate, TagListViewDelegate, UINavigationControllerDelegate, selectedPassion {
    func passion(passion: [String]) {
        arrPassion.removeAll()
        lblPassion.isHidden = true
        arrPassion.append(contentsOf: passion)
        txtPassion.textFont = AppFonts.Poppins_Medium.withSize(17)
        txtPassion.alignment = .leading
        txtPassion.addTags(arrPassion)
        
    }
    
    
    //MARK:- VARIABLE
   
    var selectedImage = 0
    var removeImage = 0
    var arrPassion:[String] = []
    var isFromLogin = false
    var arrKids:[String] = []

    var onPopView: (() -> Void)?
    fileprivate var latitude: String = ""
    fileprivate var longitude: String = ""
    fileprivate var selectedImageIndex = 0
    fileprivate var imagePicker: ImagePicker!
    fileprivate let placeHolder = "About Information"
    
    fileprivate var selectedGender = -1
    fileprivate var numberOfKids = 0
    fileprivate var profile: UserProfile = UserProfile(JSON.null)
    fileprivate var locationManager: CLLocationManager?
    
    var pickerView: UIPickerView!
    var arrImgParam: [String] = ["0", "0", "0", "0", "0", "0"]
    
    
    //MARK:- OUTLET
    
    
    @IBOutlet var btnAddImages: [UIButton]!
    @IBOutlet weak var txtEmail: CustomTextField!
    @IBOutlet var arrProfileBtn: [UIButton]!

    @IBOutlet weak var txtDate: CustomTextField!
   
    @IBOutlet weak var txtFirstName: CustomTextField!
    @IBOutlet weak var txtLastName: CustomTextField!
    @IBOutlet weak var txtAboutView: UITextView!{
        didSet {
            txtAboutView.delegate = self
        }
    }

    
    @IBOutlet var arrImageProfile: [UIImageView]!
    @IBOutlet var arrGenderBtn: [UIButton]!
    @IBOutlet weak var txtJobTitle: UITextField!
    @IBOutlet weak var txtOrientation: CustomTextField!
 
    @IBOutlet weak var txtPassion: TagListView!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblCharacterLeft: UILabel!
    @IBOutlet var arrStackView: [UIStackView]!
    @IBOutlet weak var txtNumberOfKids: CustomTextField!
  
    @IBOutlet var txtKids: [UITextField]!
    @IBOutlet weak var lblPassion: UILabel!
    
    
    //MARK:- LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        setupUI()
        txtFirstName.setPlaceHolderColor()
        txtLastName.setPlaceHolderColor()
        txtDate.setPlaceHolderColor()
        txtPassion.delegate = self
        txtEmail.setPlaceHolderColor()
        txtNumberOfKids.setPlaceHolderColor()
        txtOrientation.setPlaceHolderColor()
      
       
        
        
    }
    @IBAction func onPressbtnPassion(_ sender: Any) {
        
        let vc = TagListVC.instantiate(fromAppStoryboard: .Profile)
        vc.delegate = self
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func onPressAddImagebtn(_ sender: UIButton) {
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
            arrImageProfile[self.selectedImage].image = image
            btnAddImages[self.selectedImage].isHidden = true
            arrProfileBtn[self.selectedImage].isHidden = false
            dismiss(animated: true, completion: nil)
    }
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
    
    @IBAction func onProfileBtnTap(_ sender: UIButton) {
        
        arrImageProfile[sender.tag].image = nil
        arrProfileBtn[sender.tag].isHidden = true
        btnAddImages[sender.tag].isHidden = true
     
    }
    
    @IBAction func onGenderBtnTap(_ sender: UIButton) {
        
        for btn in arrGenderBtn {
            if btn.tag == sender.tag {
                btn.isSelected = true
                selectedGender = btn.tag
            } else {
                btn.isSelected = false
            }
        }
    }
    
    
    @IBAction func onSexualOrientationTap(_ sender: UIControl) {
        let alert = UIAlertController(title: "Choose Secual Orientation", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Heterosexual", style: .default, handler: { _ in
            self.txtOrientation.text = "Heterosexual"
        }))

        alert.addAction(UIAlertAction(title: "Homosexual", style: .default, handler: { _ in
            self.txtOrientation.text = "Homosexual"
            }))
        
        alert.addAction(UIAlertAction(title: "Bisexual", style: .default, handler: { _ in
            self.txtOrientation.text = "Bisexual"
            }))

        alert.addAction(UIAlertAction(title: "Asexual", style: .default, handler: { _ in
            self.txtOrientation.text = "Asexual"
            }))


        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))

        self.present(alert, animated: true, completion: nil)
        
        
    }

    @IBAction func onLocationTap(_ sender: UIControl) {
        
        let gmsACVC = GMSAutocompleteViewController()
        gmsACVC.delegate = self
        gmsACVC.modalPresentationStyle = .fullScreen
        present(gmsACVC, animated: true, completion: nil)
        
    }
    
    @IBAction func onNumberOfKidsTap(_ sender: UIControl) {
        let alert = UIAlertController(title: "No of Kids", message: "Selct No of Kids", actionNames: ["0", "1", "2", "3", "4", "5"]) { (action) in
            for i in 0..<5 {
                self.txtKids[i].text = nil
                self.arrKids.removeAll()
                
            }
            
            for i in 0..<self.arrStackView.count {
                self.arrStackView[i].isHidden = true
            }
            
            self.txtNumberOfKids.text = action.title ?? ""
            
            self.numberOfKids = Int(action.title ?? "0") ?? 0
            
            guard let count = Int(action.title ?? "0"), count > 0 else {
                
                self.tableView.reloadData()
                self.tableView.invalidateIntrinsicContentSize()
                self.tableView.layoutIfNeeded()
                
                return
            }
            
            for i in 0..<count {
                self.arrStackView[i].isHidden = false
            }
            
            self.tableView.reloadData()
            self.tableView.invalidateIntrinsicContentSize()
            self.tableView.layoutIfNeeded()
            
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func onKidTypeTap(_ sender: UIControl) {
        
        let alert = UIAlertController(title: "Choose Kid Type", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "New born", style: .default, handler: { _ in
            
            self.txtKids[sender.tag].text = "New born"
            self.arrKids.append("New born")
          
        }))

        alert.addAction(UIAlertAction(title: "Infant", style: .default, handler: { _ in
            
            self.txtKids[sender.tag].text = "Infant"
            self.arrKids.append("Infant")
        
            }))
        

        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))

        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    
}

extension CreateProfileTVC {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 226
        }
        
        if indexPath.section == 1 {
            return 100
        }
        
        if indexPath.section == 2 {
            return 448
        }
        
        if indexPath.section == 4 {
            return CGFloat((numberOfKids * 50) + 66 + (numberOfKids * 8))
        }
        
        if indexPath.section == 5 {
            return 80
        }
        return UITableView.automaticDimension
    }
}


extension CreateProfileTVC {
    
    fileprivate func setupUI() {
        
        navigationItem.setHidesBackButton(true, animated: true)
        
        txtDate.setInputViewDatePicker(target: self, selector: #selector(self.onDoneBtnTap))
    }
    
    fileprivate func setupDataUI() {
        
        for btn in arrProfileBtn {
            btn.isSelected = false
            btn.isEnabled = false
        }
        
        for (i, image) in profile.arrImage.enumerated() {
            self.arrImageProfile[i].setImage(image)
            self.arrProfileBtn[i].isSelected = true
            self.arrProfileBtn[i].isEnabled = true
        }
        
        txtFirstName.text = profile.firstName
        txtLastName.text = profile.lastName
        txtAboutView.text = profile.about.count > 0 ? profile.about : placeHolder
    
        txtDate.text = profile.dateOfBirth
       

        
        if profile.address.count == 0 {
            locationManager = CLLocationManager()
            locationManager?.delegate = self
            locationManager?.requestAlwaysAuthorization()
        }
        
        
    }
}



extension CreateProfileTVC {
    
    
    @IBAction func onAddressFieldEditingBegin(_ sender: UITextField) {
        
        guard isFromLogin else {
            sender.resignFirstResponder()
            return
        }
        guard (sender.text?.count ?? 0) == 0 else {
            sender.resignFirstResponder()
            return }
        sender.resignFirstResponder()
        let gmsACVC = GMSAutocompleteViewController()
        gmsACVC.delegate = self
        gmsACVC.modalPresentationStyle = .fullScreen
        present(gmsACVC, animated: true, completion: nil)
    }

    
    @IBAction func onImageBtnTap(_ sender: UIControl) {
        imagePicker = ImagePicker(presentationController: self, delegate: self)
        imagePicker.present(from: sender)
        selectedImageIndex = sender.tag
    }
    
    


    @objc fileprivate func onBackBtnTap() {
        onPopView?()
        navigationController?.popViewController(animated: false)
    }
    
    /*
    @IBAction func onAddressFieldEditingBegin(_ sender: UITextField) {
                sender.resignFirstResponder()
                let gmsACVC = GMSAutocompleteViewController()
                gmsACVC.delegate = self
                gmsACVC.modalPresentationStyle = .fullScreen
                present(gmsACVC, animated: true, completion: nil)
    }
    */
    
    @objc fileprivate func onDoneBtnTap() {
        
        if let datePicker = txtDate.inputView as? UIDatePicker, txtDate.isFirstResponder {
            txtDate.text = DateFormatter().ecmDateFormatter.string(from: datePicker.date)
            txtDate.resignFirstResponder()
        }
    }
    
    @IBAction func onNextControlTap(_ sender: UIControl) {
    
        
        let img1 = arrImageProfile[0].image
        let img2 = arrImageProfile[1].image
        let img3 = arrImageProfile[2].image
        let img4 = arrImageProfile[3].image
        let img5 = arrImageProfile[4].image
        let img6 = arrImageProfile[5].image
        
        let imgData1 = img1?.jpegData(compressionQuality: 0.5)
        let imgData2 = img2?.jpegData(compressionQuality: 0.5)
        let imgData3 = img3?.jpegData(compressionQuality: 0.5)
        let imgData4 = img4?.jpegData(compressionQuality: 0.5)
        let imgData5 = img5?.jpegData(compressionQuality: 0.5)
        let imgData6 = img6?.jpegData(compressionQuality: 0.5)
        
        var source: [String: Data] = [:]
        
        if imgData1 != nil {
            source.merge(["profile_image1": imgData1!]) { (current, _) -> Data in
                return current
            }
        }
        
        if imgData2 != nil {
            source.merge(["profile_image2": imgData2!]) { (current, _) -> Data in
                return current
            }
        }
        
        if imgData3 != nil {
            source.merge(["profile_image3": imgData3!]) { (current, _) -> Data in
                return current
            }
        }
        
        if imgData4 != nil {
            source.merge(["profile_image4": imgData4!]) { (current, _) -> Data in
                return current
            }
        }
        
        if imgData5 != nil {
            source.merge(["profile_image5": imgData5!]) { (current, _) -> Data in
                return current
            }
        }
        
        if imgData6 != nil {
            source.merge(["profile_image6": imgData6!]) { (current, _) -> Data in
                return current
            }
        }
        
        guard source.count > 0 else {
            self.showAlert("Please upload at least one picture")
            return
        }
        
        
        
        
//        guard let img1 = arrImageProfile[0].image, let img2 = arrImageProfile[1].image, let img3 = arrImageProfile[2].image, let img4 = arrImageProfile[3].image, let img5 = arrImageProfile[4].image else {
//            self.showAlert("Please Select All Profile Image")
//            return
//        }
        
    
        
        guard let firstName = txtFirstName.text, firstName.count > 0 else {
            self.showAlert("Please \(txtFirstName.placeholder ?? "")")
            return
        }
        
        guard let lastName = txtLastName.text, lastName.count > 0 else {
            self.showAlert("Please \(txtLastName.placeholder ?? "")")
            return
        }
        
        guard let sexualOrientation = txtOrientation.text, sexualOrientation.count > 0, sexualOrientation != placeHolder else {
            self.showAlert("Please \(placeHolder)")
            return
        }
    
        guard let dob = txtDate.text, dob.count > 0 else {
            self.showAlert("Please Select Date Of Birth")
            return
        }
        
        guard let email = txtEmail.text, email.count > 0, email != placeHolder else {
            self.showAlert("Please Enter Email")
            return
        }
        
        guard let loc = lblLocation.text, loc.count > 0 else {
            self.showAlert("Please Select Location")
            return
        }
        
        guard let noOfkids = txtNumberOfKids.text, noOfkids.count > 0 else {
            self.showAlert("Please Enter No of Kids")
            return
        }
       
       
        guard email.isValidEmail else {
            self.showAlert("Please Enter Valid Email")
            return
        }
       
        
        
    
    
        let parameters =
            [
                "first_name": firstName,
                "last_name": lastName,
                "email": email,
                "dob": dob,
                "job_title":txtJobTitle.text ?? "",
                "about": txtAboutView.text ?? "",
                "sexual_orientation":sexualOrientation,
                "kids": arrKids.joined(separator: ","),
                "num_of_kids": noOfkids,
                "gender": selectedGender == 0 ? "Male" : selectedGender == 1 ? "Female" : "Other",
                "latitude": latitude,
                "longitude": longitude,
                "address": loc,
                "passion":arrPassion.joined(separator: ",")
               
            ] as [String : String]
        
//        for i in 1...arrImgParam.count {
//            parameters.merge(["img\(i)": arrImgParam[i-1]]) { (current, _) -> String in
//                return current
//            }
//        }
        
//        let source = [
//            "profile_image1": imgData1,
//            "profile_image2": imgData2,
//            "profile_image3": imgData3,
//            "profile_image4": imgData4,
//            "profile_image5": imgData5
//        ]
        
        
        addProfile(source: source, parameters: parameters)
        
    }

}



extension CreateProfileTVC {
    
   
    fileprivate func getProfile() {
        showHUD()
        NetworkManager.Profile.getMyProfile({ (profile) in
            self.hideHUD()
            self.profile = profile
            self.setupDataUI()
        }) { (error) in
            self.hideHUD()
            self.showAlert(error)
        }
    }
    
   
    fileprivate func addProfile(source: [String: Data], parameters: [String: String]) {
        showHUD()
        NetworkManager.Profile.addProfile(source: source, params: parameters, { (message) in
            self.hideHUD()
//            self.showAlert(message)
            
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

}



extension CreateProfileTVC: ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        guard let image = image else {
            return
        }
        openCropViewController(image: image)
    }
}



extension CreateProfileTVC {
    
    fileprivate func openCropViewController(image: UIImage) {
        let cropController = CropViewController(croppingStyle: .default, image: image)
        //cropController.modalPresentationStyle = .fullScreen
        cropController.delegate = self
        
        // Uncomment this if you wish to provide extra instructions via a title label
        //cropController.title = "Crop Image"
        
        // -- Uncomment these if you want to test out restoring to a previous crop setting --
        //cropController.angle = 90 // The initial angle in which the image will be rotated
        //cropController.imageCropFrame = CGRect(x: 0, y: 0, width: 2848, height: 4288) //The initial frame that the crop controller will have visible.
        
        // -- Uncomment the following lines of code to test out the aspect ratio features --
        cropController.aspectRatioPreset = .presetCustom
        cropController.customAspectRatio = CGSize(width: 9.0, height: 16.0)
        
        //Set the initial aspect ratio as a square
        cropController.aspectRatioLockEnabled = true // The crop box is locked to the aspect ratio and can't be resized away from it
        cropController.resetAspectRatioEnabled = false // When tapping 'reset', the aspect ratio will NOT be reset back to default
        cropController.aspectRatioPickerButtonHidden = true
        
        // -- Uncomment this line of code to place the toolbar at the top of the view controller --
        //cropController.toolbarPosition = .top
        
        cropController.rotateButtonsHidden = true
        cropController.rotateClockwiseButtonHidden = true
        
        //cropController.doneButtonTitle = "Title"
        //cropController.cancelButtonTitle = "Title"
        
        //cropController.toolbar.doneButtonHidden = true
        //cropController.toolbar.cancelButtonHidden = true
        cropController.toolbar.clampButtonHidden = true
        
        self.present(cropController, animated: true, completion: nil)
    }
    
}



extension CreateProfileTVC: CropViewControllerDelegate {
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: true, completion: nil)
        arrImageProfile[selectedImageIndex].image = image
        arrProfileBtn[selectedImageIndex].isSelected = true
        arrProfileBtn[selectedImageIndex].isEnabled = true
        arrImgParam[selectedImageIndex] = "0"
    }
}



extension CreateProfileTVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeHolder {
            textView.text = nil
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeHolder
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        lblCharacterLeft.text = "Characters left: \(150 - textView.text.count)"
        return textView.text.count < 150
    }
    
}



//extension CreateProfileTVC: UITextFieldDelegate {
//
//    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//        guard let height = Int(textField.text ?? "") else {
//            showToast("Please enter proper height")
//            return false
//        }
//
//        guard height <= 200 && height >= 140 else {
//            showToast("Height should be between 140 and 200")
//            return false
//        }
//
//        return true
//    }
//
//}



extension CreateProfileTVC: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        //        txtAddress.text = place.name
        let latitude = "\(place.coordinate.latitude)"
        let longitude = "\(place.coordinate.longitude)"
        var locationName = ""
        var country = ""
        var state = ""
        var city = ""
        var postalCode = ""
        
        let placeName = place.name ?? ""
        let address = place.formattedAddress ?? ""
        
        var addArray:[String] = []
        for component in place.addressComponents ?? [] {
            if component.types.contains("locality") {
                locationName = component.name
            }
            if component.types.contains("administrative_area_level_2") {
                city = component.name
                if city.count > 0 {
                    addArray.append(city)
                }
            }
            if component.types.contains("administrative_area_level_1") {
                state = component.name
                if state.count > 0 {
                    addArray.append(state)
                }
            }
            if component.types.contains("country") {
                country = component.name
            }
            if component.types.contains("postal_code") {
                postalCode = component.name
            }
        }
        
        let addressString = addArray.joined(separator: ", ")
        //getAddressFromCenterCoordinate(centerCoordinate: place.coordinate)
        self.latitude = latitude
        self.longitude = longitude
        self.lblLocation.text = addressString
        dismiss(animated: true, completion: nil)
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
}



extension CreateProfileTVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            manager.startUpdatingLocation()
            
            if let coordinate = manager.location?.coordinate {
                self.getAddressFromCenterCoordinate(centerCoordinate: coordinate)
            }
            
        } else {
            
            let alert = UIAlertController(title: "Turn On Location Service", message: "Turn On Location Service to Allow 'ZOMATE' to determine Your Location", actionName: "Setting") { (_) in
                if let settingURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingURL)
                }
            }
            
            self.present(alert, animated: true, completion: nil)
            
//            self.txtAddress.isEnabled = true
//            self.imgAddressDropdown.isHidden = false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            //            Filter.longitude = "\(location.coordinate.longitude)"
            //            Filter.latitude = "\(location.coordinate.latitude)"
        }
    }
}



extension CreateProfileTVC {
    
    func getAddressFromCenterCoordinate(centerCoordinate : CLLocationCoordinate2D){
        
        let latitude = "\(centerCoordinate.latitude)"
        let longitude = "\(centerCoordinate.longitude)"
        var locationName = ""
        var country = ""
        var state = ""
        var city = ""
        var postalCode = ""
        self.latitude = latitude
        self.longitude = longitude
       
        
        let location: CLLocation = CLLocation(latitude:centerCoordinate.latitude, longitude: centerCoordinate.longitude)
        
        showHUD()
        CLGeocoder().reverseGeocodeLocation(location, completionHandler:
                                                {(placemarks, error) in
                                                    self.hideHUD()
                                                    if (error != nil)
                                                    {
//                                                        self.txtAddress.isEnabled = false
//                                                        self.imgAddressDropdown.isHidden = false
                                                        
                                                        print("reverse geodcode fail: \(error?.localizedDescription ?? "Error")")
                                                    } else {
//                                                        self.txtAddress.isEnabled = true
//                                                        self.imgAddressDropdown.isHidden = true
                                                    }
                                                    guard let place = placemarks, place.count > 0 else {
                                                        return
                                                        
                                                    }
                                                    
                                                    let pm = place[0]
                                                    
                                                    var addArray:[String] = []
//                                                    if let name = pm.name {
//                                                        addArray.append(name)
//                                                    }
                                                    if let locality = pm.locality {
                                                        addArray.append(locality)
                                                        city = locality
                                                    } else {
                                                        addArray.append("")
                                                        city = ""
                                                    }
                                                    
                                                    if let administrativeArea = pm.administrativeArea {
                                                        addArray.append(administrativeArea)
                                                        state = administrativeArea
                                                    }
                                                    
//                                                    if let countryName = pm.country {
//                                                        addArray.append(countryName)
//                                                        country = countryName
//                                                    }
//                                                    if let postalCodeValue = pm.postalCode {
//                                                        addArray.append(postalCodeValue)
//                                                        postalCode = postalCodeValue
//                                                    }
                                                    
                                                    let addressString = addArray.joined(separator: ", ")
                                                    locationName = addressString
                                                    
                                                    /*
                                                    let param = [
                                                        "latitude": latitude,
                                                        "longitude": longitude,
                                                        "type": "insert",
                                                        "location": locationName,
                                                        "country": country,
                                                        "state": state,
                                                        "city": city
                                                    ]
                                                    */
                                                    self.latitude = latitude
                                                    self.longitude = longitude
                                                    self.lblLocation.text = locationName
                                                    
                                                })
        
    }
}

extension CreateProfileTVC {
    
    func showAlert(_ alert: String) {
        let alert = UIAlertController(title: "Oops!", message: alert)
        self.present(alert, animated: true, completion: nil)
    }
}
