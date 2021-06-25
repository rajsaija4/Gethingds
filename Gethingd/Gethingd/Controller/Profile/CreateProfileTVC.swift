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

class CreateProfileTVC: UITableViewController {
    
    //MARK:- VARIABLE
    
    var isFromLogin = false
    var freemiumPlanActiveMsg = String()
    var onPopView: (() -> Void)?
    fileprivate var selectedSunSign: Int = 0
    fileprivate var selectedMoonSign: Int = 0
    fileprivate var selectedRisingSign: Int = 0
    fileprivate var latitude: String = ""
    fileprivate var longitude: String = ""
    fileprivate var selectedImageIndex = 0
    fileprivate var imagePicker: ImagePicker!
    fileprivate let placeHolder = "Tell us something about yourself"
    
    fileprivate var selectedGender = -1
    fileprivate var selectedLookingFor = -1
    fileprivate var profile: UserProfile = UserProfile(JSON.null)
    fileprivate var arrHeight: [Double] = []
    fileprivate var locationManager: CLLocationManager?
    fileprivate var instagramTestUser: InstagramTestUser? = nil
    fileprivate var instagramUser: InstagramUser? = nil
    
    var pickerView: UIPickerView!
    let feetList = Array(3...9)
    let inchList = Array(0...11)
    let numberOfComponents = 4
    var arrImgParam: [String] = ["0", "0", "0", "0", "0"]
    
    
    //MARK:- OUTLET
    
    
    @IBOutlet var arrProfileBtn: [UIButton]!
    @IBOutlet weak var imgAddressDropdown: UIImageView!
    @IBOutlet var arrLookingForSelect: [UIImageView]!
    @IBOutlet var arrGenderSelect: [UIImageView]!
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var lblHeight: UILabel!
    @IBOutlet weak var txtHeight: UITextField!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtNickName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtAboutView: UITextView!{
        didSet {
            txtAboutView.delegate = self
        }
    }
    @IBOutlet weak var btnInstaGram: UIButton!
    @IBOutlet weak var btnRemoveInsta: UIButton!
    
    @IBOutlet var arrImageProfile: [UIImageView]!
    @IBOutlet weak var sunSignCollectionView: UICollectionView!{
        didSet{
            sunSignCollectionView.delegate = self
            sunSignCollectionView.dataSource = self
            sunSignCollectionView.registerCell(SignCell.self)
        }
    }
    
    @IBOutlet weak var moonSignCollectionView: UICollectionView!{
        didSet{
            moonSignCollectionView.delegate = self
            moonSignCollectionView.dataSource = self
            moonSignCollectionView.registerCell(SignCell.self)
        }
    }
    
    @IBOutlet weak var risingSignCollectionView: UICollectionView!{
        didSet{
            risingSignCollectionView.delegate = self
            risingSignCollectionView.dataSource = self
            risingSignCollectionView.registerCell(SignCell.self)
        }
    }
    
    //MARK:- LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
    }
    

    @IBAction func onProfileBtnTap(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            sender.isEnabled = false
            arrImageProfile[sender.tag].image = nil
            arrImgParam[sender.tag] = "1"
        }
    }
    
   
    
}



extension CreateProfileTVC {
    
    fileprivate func setupUI() {
        
        navigationController?.isNavigationBarHidden = false
        
        if isFromLogin {
            navigationController?.addBackButtonWithTitle(title: "Create Profile (slide down to apply)")
        } else {
            navigationController?.addBackButtonWithTitle(title: "Update Profile (slide down to apply)", action: #selector(self.onBackBtnTap))
        }
        
        navigationItem.setHidesBackButton(true, animated: true)
        
        txtDate.setInputViewDatePicker(target: self, selector: #selector(self.onDoneBtnTap))
        
        self.pickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        txtHeight.inputView = self.pickerView
        self.pickerView.backgroundColor = UIColor.white
        txtHeight.inputView = self.pickerView
        
        if freemiumPlanActiveMsg.count > 0 {
            self.showFreemiumPlanActiveAlert()
        }
        
        getProfile()
//        getHeight()
    }
    
    fileprivate func setupDataUI() {
        selectedSunSign = Int(profile.sunSignId) ?? 0
        selectedMoonSign = Int(profile.moonSignId) ?? 0
        selectedRisingSign = Int(profile.risingSignId) ?? 0
        
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
        txtNickName.text = profile.nickName
        txtAboutView.text = profile.about.count > 0 ? profile.about : placeHolder
        
        let feet = (Int(profile.userHeight) ?? 0) / 12
        let inches = (Int(profile.userHeight) ?? 0) % 12

        let userHeight = "\(feet)'\(inches)''"
        
        
//        lblHeight.text = userHeight
        
        txtHeight.text = profile.userHeight == "0" ? "Height" : userHeight
        txtAddress.text = profile.address
        txtAddress.isEnabled = isFromLogin
        
//        imgAddressDropdown.isHidden = profile.address.count == 0
//        imgAddressDropdown.isHidden = true
        txtEmail.text = profile.email
        txtDate.text = profile.dateOfBirth
        if profile.lookingFor.count > 0 {
            selectedLookingFor = profile.lookingFor.lowercased() == "Female".lowercased() ? 0 : 1
        }
        
        if profile.gender.count > 0 {
            selectedGender = profile.gender.lowercased() == "Male".lowercased() ? 0 : 1
        }
        
        if profile.instagramId.count > 0 {
            btnInstaGram.setTitle(profile.instagramId, for: .normal)
            btnInstaGram.isEnabled = false
            btnRemoveInsta.isHidden = false
        } else {
            btnInstaGram.setTitle("Connect With Instagram", for: .normal)
            btnRemoveInsta.isHidden = true
            btnInstaGram.isEnabled = true
        }
              
        
        if selectedGender == 0 {
            arrGenderSelect[0].image = UIImage.selectedImage
            arrGenderSelect[1].image = UIImage.unSelectedImage
        } else if selectedGender == 1 {
            arrGenderSelect[1].image = UIImage.selectedImage
            arrGenderSelect[0].image = UIImage.unSelectedImage
        }
        
        if selectedLookingFor == 0 {
            arrLookingForSelect[0].image = UIImage.selectedImage
            arrLookingForSelect[1].image = UIImage.unSelectedImage
        } else if selectedLookingFor == 1 {
            arrLookingForSelect[1].image = UIImage.selectedImage
            arrLookingForSelect[0].image = UIImage.unSelectedImage
        }
        
        
        sunSignCollectionView.reloadData()
        moonSignCollectionView.reloadData()
        risingSignCollectionView.reloadData()
        
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
    
    @IBAction func onConnectInstaBtnTap(_ sender: UIButton) {
        let vc: InstaLoginWebVC = InstaLoginWebVC.instantiate(fromAppStoryboard: .Profile)
        vc.instaGramUser = { user in
            self.instagramTestUser = user
            self.getInstagramProfile()
        }
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func onRemoveInstaBtnTap(_ sender: UIButton) {
        instagramUser = nil
        instagramTestUser = nil
        addInstagramAccount()
    }
    
    @IBAction func onImageBtnTap(_ sender: UIControl) {
        imagePicker = ImagePicker(presentationController: self, delegate: self)
        imagePicker.present(from: sender)
        selectedImageIndex = sender.tag
    }
    
    @IBAction func onGenderSelect(_ sender: UIControl) {
        for i in 0..<arrGenderSelect.count {
            arrGenderSelect[i].image = i == sender.tag ? UIImage.selectedImage : UIImage.unSelectedImage
        }
        selectedGender = sender.tag
    }
    

    @IBAction func onLookingForControlTap(_ sender: UIControl) {
        for i in 0..<arrLookingForSelect.count {
            arrLookingForSelect[i].image = i == sender.tag ? UIImage.selectedImage : UIImage.unSelectedImage
        }
        selectedLookingFor = sender.tag
    }
    
    @IBAction func onHeightControlTap(_ sender: UIControl) {
       
        var heights: [String] = []
        for i in 145..<201 {
            heights.append("\(i)")
        }
        let alert = UIAlertController(title: "Your Height", message: "Select Height", actionNames: heights) { (action) in
            guard let height = action.title else { return }
            self.lblHeight.text = height
        }
        
        self.present(alert, animated: true, completion: nil)
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
        
        guard selectedSunSign != 0 else {
            self.showAlert("Please Select Sun Sign")
            return
        }
        
        let img1 = arrImageProfile[0].image
        let img2 = arrImageProfile[1].image
        let img3 = arrImageProfile[2].image
        let img4 = arrImageProfile[3].image
        let img5 = arrImageProfile[4].image
        
        let imgData1 = img1?.jpegData(compressionQuality: 0.5)
        let imgData2 = img2?.jpegData(compressionQuality: 0.5)
        let imgData3 = img3?.jpegData(compressionQuality: 0.5)
        let imgData4 = img4?.jpegData(compressionQuality: 0.5)
        let imgData5 = img5?.jpegData(compressionQuality: 0.5)
        
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
        
        guard let nickName = txtNickName.text, nickName.count > 0 else {
            self.showAlert("Please \(txtNickName.placeholder ?? "")")
            return
        }
        
        guard let email = txtEmail.text, email.count > 0 else {
            self.showAlert("Please \(txtEmail.placeholder ?? "")")
            return
        }
        
        guard email.isValidEmail else {
            self.showAlert("Please Enter Valid Email Address")
            return
        }
        
        
        guard let aboutInfo = txtAboutView.text, aboutInfo.count > 0, aboutInfo != placeHolder else {
            self.showAlert("Please \(placeHolder)")
            return
        }
        
        guard let userHeight = txtHeight.text, userHeight != "Height" else {
            self.showAlert("Please Enter Height")
            return
        }
        
        guard let feet = Int(userHeight.components(separatedBy: "'")[0]),  let inch = Int(userHeight.components(separatedBy: "'")[1]) else {
            return
        }
        
        //
        
        let newUserHeight = ((feet * 12) + inch)
        
        guard newUserHeight > 0 else {
            self.showAlert("Please Enter Height")
            return
        }
        
        guard let dob = txtDate.text, dob.count > 0 else {
            self.showAlert("Please Select Date Of Birth")
            return
        }
        
        guard selectedGender != -1 else {
            self.showAlert("Please Select Gender")
            return
        }
        
        guard selectedLookingFor != -1 else {
            self.showAlert("Please Select Looking For")
            return
        }
        
        guard let address = txtAddress.text, address.count > 0 else {
            self.showAlert("Please \(txtAddress.placeholder ?? "")")
            return
        }
        
        /*
        guard selectedMoonSign != 0 else {
            self.showAlert("Please Select Moon Sign")
            return
        }
        
        guard selectedRisingSign != 0 else {
            self.showAlert("Please Select Rising Sign")
            return
        }
 
        */
        
//        guard let instagramID = txtInstagram.text, instagramID.count > 0 else {
//            self.showAlert("Please \(txtInstagram.placeholder ?? "")")
//            return
//        }
        
//        guard let imgData1 = img1.jpegData(compressionQuality: 0.5), let imgData2 = img2.jpegData(compressionQuality: 0.5), let imgData3 = img3.jpegData(compressionQuality: 0.5), let imgData4 = img4.jpegData(compressionQuality: 0.5), let imgData5 = img5.jpegData(compressionQuality: 0.5) else {
//            self.showAlert("Image Data Compression Issue")
//            return
//        }
    
        
        
        var parameters =
            [
                "token": User.details.token,
                "sun_zodiac_sign_id": "\(selectedSunSign)",
                "moon_zodiac_sign_id": "\(selectedMoonSign)",
                "rising_zodiac_sign_id": "\(selectedRisingSign)",
                "first_name": firstName,
                "last_name": lastName,
                "nick_name": nickName,
                "email": email,
                "about": aboutInfo,
                "looking_for": selectedLookingFor == 0 ? "Female" : "Male",
                "gender": selectedGender == 0 ? "Male" : "Female",
                "height": "\(newUserHeight)",
                "dob": dob,
                "latitude": latitude,
                "longitude": longitude,
                "address": address
            ] as [String : String]
        
        for i in 1...arrImgParam.count {
            parameters.merge(["img\(i)": arrImgParam[i-1]]) { (current, _) -> String in
                return current
            }
        }
        
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
    
    fileprivate func getHeight() {
        NetworkManager.Profile.getHeight({ (heights) in
            self.arrHeight.removeAll()
            self.arrHeight.append(contentsOf: heights)
        }) { (error) in
//            self.showToast(error)
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
            if error == "2" {
                self.showVerifyEmailAlert()
                return
            }
            
            
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
            let alert = UIAlertController(title: "Oops!", message: error) { (_) in
                self.showVerifyEmailAlert()
            }
            self.present(alert, animated: true, completion: nil)
        }
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
    
    fileprivate func getInstagramProfile() {
        guard let testUser = instagramTestUser else { return }
        
        
        InstagramApi.shared.getInstagramUser(testUserData: testUser) { [weak self] (user) in
            
            self?.instagramUser = user
            
            DispatchQueue.main.async {
                self?.addInstagramAccount()
//                self?.btnInstaGram.setTitle(user.username, for: .normal)
                
            }
        }
    }
    
    fileprivate func addInstagramAccount() {
        
        showHUD()
        
        let param = [
            "instagram_id": instagramUser?.username ?? "",
            "insta_access_token": instagramTestUser?.access_token ?? ""
        ]
        
        NetworkManager.Profile.addInstagramAccount(param: param) { (success) in
            self.hideHUD()
            self.getProfile()
        } _: { (error) in
            self.hideHUD()
            self.showAlert(error)
        }

    }
}



extension CreateProfileTVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SignCell = collectionView.dequequReusableCell(for: indexPath)
        let index = indexPath.row + 1
        if collectionView == sunSignCollectionView {
            if index == selectedSunSign {
                cell.setupProfileCellSelected(name: "\(index)")
            } else {
                cell.setupProfileCell(name: "\(index)")
            }
            return cell
        }
        
        if collectionView == moonSignCollectionView {
            if index == selectedMoonSign {
                cell.setupProfileCellSelected(name: "\(index)")
            } else {
                cell.setupProfileCell(name: "\(index)")
            }
            return cell
        }
        
        if collectionView == risingSignCollectionView {
            if index == selectedRisingSign {
                cell.setupProfileCellSelected(name: "\(index)")
            } else {
                cell.setupProfileCell(name: "\(index)")
            }
            return cell
        }
        return cell
    }
}



extension CreateProfileTVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == sunSignCollectionView {
            selectedSunSign = indexPath.item + 1
        }
        
        if collectionView == moonSignCollectionView {
            if selectedMoonSign == indexPath.item + 1 {
                selectedMoonSign = 0
            } else {
                selectedMoonSign = indexPath.item + 1
            }
            
        }
        
        if collectionView == risingSignCollectionView {
            if selectedRisingSign == indexPath.item + 1 {
                selectedRisingSign = 0
            } else {
                selectedRisingSign = indexPath.item + 1
            }
            
        }
        
        collectionView.reloadData()

    }
}



extension CreateProfileTVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.size.height
        return CGSize(width: height * 0.8, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
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
        self.txtAddress.text = addressString
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
                                                    self.txtAddress.text = locationName
                                                    
                                                })
        
    }
}


// MARK: - UIPickerView Methods
extension CreateProfileTVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return numberOfComponents
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return feetList.count
        }else if component == 2 {
            return inchList.count
        }else {
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return "\(feetList[row])"
        }else if component == 1 {
            return "ft"
        }else if component == 2 {
            return "\(inchList[row])"
        }else {
            return "in"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let feetIndex = pickerView.selectedRow(inComponent: 0)
        let inchIndex = pickerView.selectedRow(inComponent: 2)
        txtHeight.text = "\(feetList[feetIndex])'\(inchList[inchIndex])''"
    }
}



extension CreateProfileTVC {
    
    func showAlert(_ alert: String) {
        let alert = UIAlertController(title: "Oops!", message: alert)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showFreemiumPlanActiveAlert() {
        let alert = UIAlertController(title: "Congratulations", message: freemiumPlanActiveMsg)
        self.present(alert, animated: true, completion: nil)
    }
}
