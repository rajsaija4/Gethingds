//
//  MediaPicker.swift
//  Pickers
//
//  Created by Ashish Kanani on 15/11/19.
//  Copyright © 2019. Ashish Kanani. All rights reserved.
//

/*
 App is requesting camera, photo & Microphone library access
 
 <key>NSCameraUsageDescription</key>
 <string>This app wants to take pictures &amp; videos.</string>
 <key>NSPhotoLibraryUsageDescription</key>
 <string>This app wants to use your picture &amp; video library.</string>
 <key>NSMicrophoneUsageDescription</key>
 <string>This app wants to record sound.</string>
 <key>NSPhotoLibraryAddUsageDescription</key>
 <string>This app wants to save pictures &amp; videos to your library.</string>
 
  Usage
 
 self.videoPicker = VideoPicker(presentationController: self, delegate: self)
 self.videoPicker.present(from: sender)
 
 extension ViewController: VideoPickerDelegate {
 
 func didSelect(url: URL?) {
    guard let url = url else {
      return
    }
 }
}
 
 */

import UIKit

public protocol VideoPickerDelegate: class {
    func didSelect(url: URL?)
}

open class VideoPicker: NSObject {

    private let pickerController: UIImagePickerController
    private weak var presentationController: UIViewController?
    private weak var delegate: VideoPickerDelegate?

    public init(presentationController: UIViewController, delegate: VideoPickerDelegate) {
        self.pickerController = UIImagePickerController()

        super.init()

        self.presentationController = presentationController
        self.delegate = delegate
    
        self.pickerController.delegate = self
        self.pickerController.allowsEditing = true
        self.pickerController.mediaTypes = ["public.movie"]
        self.pickerController.videoQuality = .typeHigh
    }
    
    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }
        
        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            self.pickerController.sourceType = type
            self.presentationController?.present(self.pickerController, animated: true)
        }
    }
    
    public func present(from sourceView: UIView) {

        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if let action = self.action(for: .camera, title: "Take video") {
            alertController.addAction(action)
        }
        if let action = self.action(for: .savedPhotosAlbum, title: "Camera roll") {
            alertController.addAction(action)
        }
        if let action = self.action(for: .photoLibrary, title: "Video library") {
            alertController.addAction(action)
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = sourceView
            alertController.popoverPresentationController?.sourceRect = sourceView.bounds
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }

        self.presentationController?.present(alertController, animated: true)
    }
    
    private func pickerController(_ controller: UIImagePickerController, didSelect url: URL?) {
        controller.dismiss(animated: true, completion: nil)
        
        self.delegate?.didSelect(url: url)
    }
}

extension VideoPicker: UIImagePickerControllerDelegate {
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerController(picker, didSelect: nil)
    }

    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {

        guard let url = info[.mediaURL] as? URL else {
            return self.pickerController(picker, didSelect: nil)
        }

//        //uncomment this if you want to save the video file to the media library
//        if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(url.path) {
//            UISaveVideoAtPathToSavedPhotosAlbum(url.path, self, nil, nil)
//        }
        self.pickerController(picker, didSelect: url)
    }
}

extension VideoPicker: UINavigationControllerDelegate {
    
}
