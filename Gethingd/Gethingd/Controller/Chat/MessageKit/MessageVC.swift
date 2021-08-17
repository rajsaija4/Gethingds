//
//  MessageVC.swift
//
//  Created by AK on 16/09/20.
//  Copyright © 2020 AK. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import SwiftyJSON
import Kingfisher

class MessageVC: MessagesViewController {
    
    
    //MARK:- VARIABLE
    var isLastPage = false
    fileprivate var page = 1
    fileprivate var messageList: [Message] = []
    fileprivate let refreshControl = UIRefreshControl()
       private let formatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = NSTimeZone.local
        return dateFormatter
//        return formatter
    }()
    /*
     
     */
    var onPopView: (() -> Void)?
    var oppositeUserName:String = ""
    var match_Id:Int = 0
    var conversation:ChatMessages!
    var selectedUserId:Int = 0
    var userImage: String = ""
    var isFromNotification = false
  
    
    //MARK:- OUTLET
    
    
    
    //MARK:- LIFECYCLE

    override func viewDidLoad() {
        messagesCollectionView = MessagesCollectionView(frame: .zero, collectionViewLayout: MessagesFlowLayout())
        messagesCollectionView.register(MessageCell.self)
        super.viewDidLoad()
        setupUI()
//        setupInputButton()
    }
    
//    override func viewDidDisappear(_ animated: Bool) {
//        self.viewWillDisappear(animated)
//        self.navigationController?.navigationBar.isHidden = true
//    }
//
//    private func setupInputButton() {
//        let button = InputBarButtonItem()
//        button.setSize(CGSize(width: 35, height: 35), animated: false)
//        if #available(iOS 13.0, *) {
//            button.setImage(UIImage(systemName: "camera"), for: .normal)
//            button.tintColor = UIColor(hexString: "#5F054A")
//        } else {
//            // Fallback on earlier versions
//        }
//        button.onTouchUpInside { [weak self] _ in
//            self?.presentInputActionSheet()
//        }
//        messageInputBar.setLeftStackViewWidthConstant(to: 36, animated: false)
//        messageInputBar.setStackViewItems([button], forStack: .left, animated: false)
//    }
    
//    private func presentInputActionSheet() {
//        let actionSheet = UIAlertController(title: "Attach Media",
//                                            message: "What would you like to attach?",
//                                            preferredStyle: .actionSheet)
//        actionSheet.addAction(UIAlertAction(title: "Photo", style: .default, handler: { [weak self] _ in
//            self?.presentPhotoInputActionsheet()
//        }))
//        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//
//        present(actionSheet, animated: true)
//    }
//
//    private func presentPhotoInputActionsheet() {
//        let actionSheet = UIAlertController(title: "Attach Photo",
//                                            message: "Where would you like to attach a photo from",
//                                            preferredStyle: .actionSheet)
//        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { [weak self] _ in
//
//            let picker = UIImagePickerController()
//            picker.sourceType = .camera
//            picker.delegate = self
//            picker.allowsEditing = true
//            self?.present(picker, animated: true)
//
//        }))
//        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { [weak self] _ in
//
//            let picker = UIImagePickerController()
//            picker.sourceType = .photoLibrary
//            picker.delegate = self
//            picker.allowsEditing = true
//            self?.present(picker, animated: true)
//
//        }))
//        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//
//        present(actionSheet, animated: true)
//    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppUserDefaults.save(value: selectedUserId, forKey: .selectedUserId)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = true
        AppUserDefaults.save(value: 0, forKey: .selectedUserId)
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .receiveMessage, object: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let messagesDataSource = messagesCollectionView.messagesDataSource else {
            fatalError("Ouch. nil data source for messages")
        }
        
        guard !isSectionReservedForTypingIndicator(indexPath.section) else {
            return super.collectionView(collectionView, cellForItemAt: indexPath)
        }
        
        let message = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView)
        if case .custom = message.kind {
            let cell = messagesCollectionView.dequeueReusableCell(MessageCell.self, for: indexPath)
            cell.configure(with: message, at: indexPath, and: messagesCollectionView)
            return cell
        }
        return super.collectionView(collectionView, cellForItemAt: indexPath)
    }
    

}



extension MessageVC {
    
    fileprivate func setupUI() {
        
        messageInputBar.inputTextView.placeholder = "Write a message"
        loadMessages()
        configureMessageCollectionView()
        configureMessageInputBar()
        navigationItem.setHidesBackButton(true, animated: true)
        navigationController?.isNavigationBarHidden = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(receiveNewMessage(_:)), name: .receiveMessage, object: nil)
        
        navigationController?.addBackButtonWithTitle(title: oppositeUserName, action: #selector(self.onBackBtnTap), imgUser: (userImage, #selector(self.onUserImgBtnTap)), reportAction: #selector(self.onReportBtnTap))
    }
    
    
    
    fileprivate func configureMessageCollectionView() {
        messagesCollectionView.messagesDataSource = self
        
        let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout
        layout?.sectionInset = UIEdgeInsets(top: 1, left: 8, bottom: 1, right: 8)
//        layout?.setMessageOutgoingAvatarSize(.zero)
        layout?.setMessageOutgoingMessageTopLabelAlignment(LabelAlignment(textAlignment: .right, textInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)))
        layout?.setMessageOutgoingMessageBottomLabelAlignment(LabelAlignment(textAlignment: .right, textInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 40)))
        
        layout?.setMessageIncomingAccessoryViewSize(CGSize(width: 30, height: 30))
        layout?.setMessageIncomingAccessoryViewPadding(HorizontalEdgeInsets(left: 8, right: 0))
        layout?.setMessageIncomingAccessoryViewPosition(.messageBottom)
        layout?.setMessageOutgoingAccessoryViewSize(CGSize(width: 30, height: 30))
        layout?.setMessageOutgoingAccessoryViewPadding(HorizontalEdgeInsets(left: 0, right: 8))
        
        messagesCollectionView.messageCellDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        scrollsToBottomOnKeyboardBeginsEditing = true
        maintainPositionOnKeyboardFrameChanged = true
        
        messagesCollectionView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(loadMoreMessages), for: .valueChanged)
        
        messagesCollectionView.backgroundColor = .groupTableViewBackground
    }
    
    fileprivate func configureMessageInputBar() {
        messageInputBar.delegate = self
        messageInputBar.isTranslucent = true
        messageInputBar.separatorLine.isHidden = true
        
        if #available(iOS 13.0, *) {
            messageInputBar.inputTextView.textColor = .label
            messageInputBar.inputTextView.backgroundColor = .white
        }
        messageInputBar.inputTextView.tintColor = COLOR.App
        //        messageInputBar.inputTextView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        messageInputBar.inputTextView.placeholderTextColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 36)
        messageInputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 36)
        messageInputBar.inputTextView.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1).cgColor
        messageInputBar.inputTextView.layer.borderWidth = 1.0
        messageInputBar.inputTextView.layer.cornerRadius = 16.0
        messageInputBar.inputTextView.layer.masksToBounds = true
        messageInputBar.inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        messageInputBar.setRightStackViewWidthConstant(to: 36, animated: false)
        messageInputBar.sendButton.imageView?.backgroundColor = UIColor(white: 0.85, alpha: 1)
        messageInputBar.sendButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        messageInputBar.sendButton.setSize(CGSize(width: 36, height: 36), animated: false)
        messageInputBar.sendButton.image = UIImage(named: "img_send")
        messageInputBar.sendButton.title = nil
        messageInputBar.sendButton.imageView?.layer.cornerRadius = 16
        messageInputBar.padding.bottom = 8
        messageInputBar.middleContentViewPadding.right = -38
        messageInputBar.inputTextView.textContainerInset.bottom = 8
        
        messageInputBar.sendButton
            .onEnabled { item in
                UIView.animate(withDuration: 0.3, animations: {
                    item.imageView?.backgroundColor = COLOR.App
                })
        }.onDisabled { item in
            UIView.animate(withDuration: 0.3, animations: {
                item.imageView?.backgroundColor = UIColor(white: 0.85, alpha: 1)
            })
        }
    }
}



extension MessageVC {
    
    @objc fileprivate func onBackBtnTap() {
        
        if isFromNotification {
            APPDEL?.setupMainTabBarController()
            return
        }
        
        onPopView?()
        navigationController?.popViewController(animated: false)
    }
    
    @objc fileprivate func onUserImgBtnTap() {
        let oppositeID = selectedUserId
        print("user details tap")
        let param = [
            "user_id": oppositeID
        ] as [String : Any]

        NetworkManager.Profile.getUserDetails(param: param) { response in
            let vc = UserDetailsTVC.instantiate(fromAppStoryboard: .Discover)
            vc.user = response
            let nvc = UINavigationController(rootViewController: vc)
            nvc.modalPresentationStyle = .overCurrentContext
            self.present(nvc, animated: true)
        } _: { error in
            print(error)
        }

    }
    
    @objc fileprivate func onReportBtnTap() {
        
        let alert = UIAlertController(title: "", message: "Select Option", actionNames: ["Unmatch", "Report"]) { (action) in
            guard let actionName = action.title else { return }
            let vc = ReportVC.instantiate(fromAppStoryboard: .Report)
            vc.modalPresentationStyle = .overCurrentContext
            vc.reportType = actionName
            vc.selectedUserId = self.selectedUserId
            self.present(vc, animated: true, completion: nil)
        }

        self.present(alert, animated: true, completion: nil)
        
    }
}



extension MessageVC {
    
    fileprivate func isPreviousMessageSameSender(at indexPath: IndexPath) -> Bool {
        guard indexPath.section - 1 >= 0 else { return false }
        return messageList[indexPath.section].user == messageList[indexPath.section - 1].user
    }
    
    fileprivate func isNextMessageSameSender(at indexPath: IndexPath) -> Bool {
        guard indexPath.section + 1 < messageList.count else { return false }
        return messageList[indexPath.section].user == messageList[indexPath.section + 1].user
    }
    
    fileprivate func isLastSectionVisible() -> Bool {
        guard !messageList.isEmpty else { return false }
        let lastIndexPath = IndexPath(item: 0, section: messageList.count - 1)
        return messagesCollectionView.indexPathsForVisibleItems.contains(lastIndexPath)
    }
    
    fileprivate func insertMessage(_ message: Message) {
        messageList.append(message)
        messagesCollectionView.performBatchUpdates({
            messagesCollectionView.insertSections([messageList.count - 1])
            if messageList.count >= 2 {
                messagesCollectionView.reloadSections([messageList.count - 2])
            }
        }, completion: { [weak self] _ in
            if self?.isLastSectionVisible() == true {
                self?.messagesCollectionView.scrollToBottom(animated: true)
            }
        })
    }
}



extension MessageVC {
    
    @objc func receiveNewMessage(_ notification: NSNotification) {
//        loadMessages()
        if let jsonString = notification.userInfo?["custom"] as? String,  let json = jsonString.jsonObject {
            let msg = Message(jsonNotification: json)
            self.insertMessage(msg)
        }
    }
    
    fileprivate func loadMessages() {
        guard !isLastPage else { refreshControl.endRefreshing(); return }
        
        
//        showHUD()
        let param = ["match_id": match_Id]
        NetworkManager.Chat.getMessageConversation(param: param) { (messages) in
            self.hideHUD()
            self.refreshControl.endRefreshing()
            self.messageList.removeAll()
            self.messageList.append(contentsOf: messages)
            self.messagesCollectionView.reloadData()
//            self.messagesCollectionView.reloadDataAndKeepOffset()
            self.messagesCollectionView.scrollToBottom()
            
        } _: { (error) in
            self.hideHUD()
            self.showToast(error)
            self.refreshControl.endRefreshing()
            self.onPopView?()
            self.navigationController?.popViewController(animated: false)
            
        }
    }
    
    fileprivate func sendMessage(_ text: String) {
        
        let param = ["match_id": match_Id, "message": text] as [String : Any]
        NetworkManager.Chat.sendMessageConversation(param: param) { (message) in
            self.messageInputBar.sendButton.stopAnimating()
            DispatchQueue.main.async {
                self.messageInputBar.inputTextView.placeholder = "Write a message"
                self.messagesCollectionView.scrollToBottom(animated: true)
                self.insertMessage(message)
            }
        } _: { (error) in
            self.messageInputBar.sendButton.stopAnimating()
            self.onPopView?()
            self.navigationController?.popViewController(animated: false)
        }

    }
}



extension MessageVC {
    
    @objc fileprivate func loadMoreMessages() {
        loadMessages()
    }
}



extension MessageVC: MessagesDataSource {
    
    func currentSender() -> SenderType {
        return Message.currentSender
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messageList.count
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messageList[indexPath.section]
    }
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if !isPreviousMessageSameSender(at: indexPath) {
            return NSAttributedString(string: MessageKitDateFormatter.shared.string(from: message.sentDate), attributes: [NSAttributedString.Key.font: AppFonts.Poppins_Medium.withSize(10), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        }
        return nil
    }
    
    func cellBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        return nil
    }
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if !isPreviousMessageSameSender(at: indexPath) {
            let name = message.sender.displayName
            return NSAttributedString(string: name, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)])
        }
        return nil
    }
    
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        var dateString = formatter.string(from: message.sentDate)
       
  
             let currentDate = Date()
             
            let timeZoneDate = message.sentDate
             
             if (currentDate).weeks(from: timeZoneDate) > 0 {
                 
                 if (currentDate).weeks(from: timeZoneDate) > 1 {
     //                return self.convertFromLocaltoCurrentFormatStringDateForNotification
                     dateString =  "\(currentDate.days(from: timeZoneDate)) days ago"
                 }
                 
                 dateString = "\(currentDate.weeks(from: timeZoneDate)) week ago"
             } else if currentDate.days(from: timeZoneDate) > 0 {
                 dateString =  "\(currentDate.days(from: timeZoneDate))" + (currentDate.days(from: timeZoneDate) == 1 ? " day ago" : " days ago")
             } else if currentDate.hours(from: timeZoneDate) > 0 {
                 dateString = "\(currentDate.hours(from: timeZoneDate)) hour ago"
             } else if currentDate.minutes(from: timeZoneDate) > 0 {
                 dateString = "\(currentDate.minutes(from: timeZoneDate)) minute ago"
             } else {
                 dateString = "just now"
             }
       
         
        
        return NSAttributedString(string: dateString, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2)])
    }
}



extension MessageVC: MessagesDisplayDelegate {
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .white : .darkText
    }
    
    func detectorAttributes(for detector: DetectorType, and message: MessageType, at indexPath: IndexPath) -> [NSAttributedString.Key: Any] {
        
        if isFromCurrentSender(message: message) {
            return [.foregroundColor: UIColor.white]
        } else {
            return [.foregroundColor: COLOR.App]
        }
        
        /*
        switch detector {
            case .hashtag, .mention:
                if isFromCurrentSender(message: message) {
                    return [.foregroundColor: UIColor.white]
                } else {
                    return [.foregroundColor: COLOR.App]
            }
            default: return MessageLabel.defaultAttributes
        }
        */
    }
    
    func enabledDetectors(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> [DetectorType] {
        return [.url, .address, .phoneNumber, .date, .transitInformation, .mention, .hashtag]
    }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? COLOR.App : UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        
        var corners: UIRectCorner = []
        
        if isFromCurrentSender(message: message) {
            corners.formUnion(.topLeft)
            corners.formUnion(.bottomLeft)
            if !isPreviousMessageSameSender(at: indexPath) {
                corners.formUnion(.topRight)
            }
            if !isNextMessageSameSender(at: indexPath) {
                corners.formUnion(.bottomRight)
            }
        } else {
            corners.formUnion(.topRight)
            corners.formUnion(.bottomRight)
            if !isPreviousMessageSameSender(at: indexPath) {
                corners.formUnion(.topLeft)
            }
            if !isNextMessageSameSender(at: indexPath) {
                corners.formUnion(.bottomLeft)
            }
        }
        
        return .custom { view in
            let radius: CGFloat = 16
            let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            view.layer.mask = mask
        }
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        avatarView.isHidden = isNextMessageSameSender(at: indexPath)

//        avatarView.layer.borderWidth = 2
//        avatarView.layer.borderColor = COLOR.App.cgColor
        
        guard let image = messageList[indexPath.section].image  else {
            avatarView.set(avatar: message.avatar)
            return
        }
        avatarView.kf.setImage(with: image)
    }
    

    
}



extension MessageVC: MessagesLayoutDelegate {
    
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return !isPreviousMessageSameSender(at: indexPath) ? 18 : 0
    }
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return !isPreviousMessageSameSender(at: indexPath) ? 20 : 0
    }
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return (!isNextMessageSameSender(at: indexPath) && isFromCurrentSender(message: message)) ? 16 : 0
    }
}



extension MessageVC: MessageCellDelegate {
    
    func didTapMessage(in cell: MessageCollectionViewCell) {
        guard let textMessageCell = cell as? TextMessageCell else { return }
        guard let indexPath = messagesCollectionView.indexPath(for: textMessageCell) else { return }
        //openActionSheet(for: messageList[indexPath.section])
    }
    
    func didTapAvatar(in cell: MessageCollectionViewCell) {
        guard let textMessageCell = cell as? TextMessageCell else { return }
        guard let indexPath = messagesCollectionView.indexPath(for: textMessageCell) else { return }
        //openActionSheet(for: messageList[indexPath.section])
    }
}



extension MessageVC: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        let attributedText = messageInputBar.inputTextView.attributedText!
        let range = NSRange(location: 0, length: attributedText.length)
        attributedText.enumerateAttribute(.autocompleted, in: range, options: []) { (_, range, _) in
            
            let substring = attributedText.attributedSubstring(from: range)
            let context = substring.attribute(.autocompletedContext, at: 0, effectiveRange: nil)
            print("Autocompleted: `", substring, "` with context: ", context ?? [])
        }
        
        let components = inputBar.inputTextView.components
        messageInputBar.inputTextView.text = String()
        messageInputBar.invalidatePlugins()
        messageInputBar.sendButton.startAnimating()
        messageInputBar.inputTextView.placeholder = "Sending..."
        self.parseMessages(components)
    }
    
    private func parseMessages(_ data: [Any]) {
        for component in data {
            if let str = component as? String {
                sendMessage(str)
            }
        }
    }
}



extension MessageVC {

//    fileprivate func openActionSheet(for message: Message) {

//        let alert = SkypeActionController()
//        if User.isExist, message.user.senderId == User.details.id {
//            alert.addAction(Action("Delete", style: .destructive, handler: { action in
//                self.delete(message)
//            }))
//        }else {
//            alert.addAction(Action("Report a \(message.user.displayName)", style: .default, handler: { action in
//                self.reportUser(message)
//            }))
//
//            alert.addAction(Action("Block request to \(message.user.displayName)", style: .default, handler: { action in
//                self.blockUser(message)
//            }))
//        }
//        alert.addAction(Action("Report a problem", style: .default, handler: { action in
//            self.reportIssue(message)
//        }))
//        alert.addAction(Action("Cancel", style: .cancel, handler: nil))
//
//        ROOTVC?.present(alert, animated: true, completion: nil)
//    }

}



extension MessageVC {

    fileprivate func reloadMessageView(_ message: Message) {
        guard let index: Int = messageList.firstIndex(where: { $0.messageId == message.messageId }) else { return }
        messageList.remove(at: index)
        messagesCollectionView.reloadData()
    }


//    fileprivate func delete(_ message: Message) {
//        showHUD()
//        APIManager.CHAT.delete(message.messageId, { (msg) in
//            self.hideHUD()
//            self.reloadMessageView(message)
//            let alert = UIAlertController(title: APP_NAME, message: msg)
//            self.present(alert, animated: true, completion: nil)
//        }) { (error) in
//            self.hideHUD()
//            let alert = UIAlertController(title: APP_NAME, message: error)
//            self.present(alert, animated: true, completion: nil)
//        }
//    }

//    fileprivate func reportIssue(_ message: Message) {
//        let vc = loadController(ReportVC.self)
//        vc.param = ("Enter reason to report the problem", .chat_message, message.messageId, message.sender.senderId)
//        SwiftEntryKit.display(entry: vc, using: EntryKitAttributes.popupVCAttributes)
//    }
//
//    fileprivate func reportUser(_ message: Message) {
//        let vc = loadController(ReportVC.self)
//        vc.param = ("Enter reason to report \(message.user.displayName)", .user, message.user.senderId, message.sender.senderId)
//        SwiftEntryKit.display(entry: vc, using: EntryKitAttributes.popupVCAttributes)
//    }
//
//    fileprivate func blockUser(_ message: Message) {
//        let vc = loadController(ReportVC.self)
//        vc.param = ("Enter reason to block \(message.user.displayName)", .block_user, message.user.senderId, message.sender.senderId)
//        SwiftEntryKit.display(entry: vc, using: EntryKitAttributes.popupVCAttributes)
//    }
//
//
//
}


extension MessageVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
//
        if let image = info[.editedImage] as? UIImage, let imageData =  image.pngData() {
            print(image)
//            let fileName = "photo_message_" + xxx + ".png"

            // Upload image
    }
 
    }

}
