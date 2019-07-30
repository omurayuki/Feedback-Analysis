import UIKit

class MessagesViewController: UIViewController, KeyboardHandler {
    
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var messageInputTextField: UITextField!
    @IBOutlet weak var messageExpandButton: UIButton!
    @IBOutlet weak var messageBarBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageStackViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet var messageActionButtons: [UIButton]!
    
//    private let manager = MessageManager()
    private let imageService = ImagePickerService()
    private var messages: [Message]?
    
    var conversation: Conversation?
    var bottomInset: CGFloat {
        return view.safeAreaInsets.bottom + 50
    }
    
    func inject(conversation: Conversation) {
        self.conversation = conversation
        //// conversationsをinjectして、その中身のidなどをみてmessageがあるかどうかをdbから判断
        //// messageはsendで使うからuserdefaultsなどで一時的に保存するべき
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addKeyboardObservers() {[weak self] state in
            guard state else { return }
            self?.messageTableView.scroll(to: .bottom, animated: true)
        }
    }
}

extension MessagesViewController {
    
    //// 前画面からのrecieveでfetchMessagesを走らす(conversationを引数にとって)
    private func fetchMessages() {
//        manager.messages(for: conversation) {[weak self] messages in
//            self?.messages = messages.sorted(by: {$0.timestamp < $1.timestamp})
//            self?.tableView.reloadData()
//            self?.tableView.scroll(to: .bottom, animated: true)
//        }
    }
    
    private func send(_ message: Message) {
//        manager.create(message, conversation: conversation) {[weak self] response in
//            guard let weakSelf = self else { return }
//            if response == .failure {
//                weakSelf.showAlert()
//                return
//            }
//            weakSelf.conversation.timestamp = Int(Date().timeIntervalSince1970)
//            switch message.contentType {
//            case .none: weakSelf.conversation.lastMessage = message.message
//            case .photo: weakSelf.conversation.lastMessage = "Attachment"
//            case .location: weakSelf.conversation.lastMessage = "Location"
//            default: break
//            }
//            if let currentUserID = UserManager().currentUserID() {
//                weakSelf.conversation.isRead[currentUserID] = true
//            }
//            ConversationManager().create(weakSelf.conversation)
//        }
    }
    
    //// revieveでfetchUserNameする
    private func fetchUserName() {
//        guard let currentUserID = UserManager().currentUserID() else { return }
//        guard let userID = conversation.userIDs.filter({$0 != currentUserID}).first else { return }
//        UserManager().userData(for: userID) {[weak self] user in
//            guard let name = user?.name else { return }
//            self?.navigationItem.title = name
//        }
    }
    
    private func showActionButtons(_ status: Bool) {
        guard !status else {
            messageStackViewWidthConstraint.constant = 112
            UIView.animate(withDuration: 0.3) {
                self.messageExpandButton.isHidden = true
                self.messageExpandButton.alpha = 0
                self.messageActionButtons.forEach( {$0.isHidden = false} )
                self.view.layoutIfNeeded()
            }
            return
        }
        guard messageStackViewWidthConstraint.constant != 32 else { return }
        messageStackViewWidthConstraint.constant = 32
        UIView.animate(withDuration: 0.3) {
            self.messageExpandButton.isHidden = false
            self.messageExpandButton.alpha = 1
            self.messageActionButtons.forEach( {$0.isHidden = true} )
            self.view.layoutIfNeeded()
        }
    }
}

extension MessagesViewController {
    
    @IBAction func sendMessagePressed(_ sender: Any) {
//        guard let text = inputTextField.text, !text.isEmpty else { return }
//        let message = ObjectMessage()
//        message.message = text
//        message.ownerID = UserManager().currentUserID()
//        inputTextField.text = nil
//        showActionButtons(false)
//        send(message)
    }
    
    @IBAction func sendImagePressed(_ sender: UIButton) {
//        imageService.pickImage(from: self, allowEditing: false, source: sender.tag == 0 ? .photoLibrary : .camera) {[weak self] image in
//            let message = ObjectMessage()
//            message.contentType = .photo
//            message.profilePic = image
//            message.ownerID = UserManager().currentUserID()
//            self?.send(message)
//            self?.inputTextField.text = nil
//            self?.showActionButtons(false)
//        }
    }
    
    @IBAction func expandItemsPressed(_ sender: UIButton) {
        showActionButtons(true)
    }
}

extension MessagesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let message = messages?[indexPath.row] else { return UITableViewCell() }
        if message.contentType == .none {
            let cell = tableView.dequeueReusableCell(withIdentifier: message.ownerID == AppUserDefaults.getAuthToken() ? "MessageTableViewCell" : "UserMessageTableViewCell") as! MessageTableViewCell
            cell.set(message)
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: message.ownerID == AppUserDefaults.getAuthToken() ? "MessageAttachmentTableViewCell" : "UserMessageAttachmentTableViewCell") as! MessageAttachmentTableViewCell
        cell.delegate = self
        cell.set(message)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard tableView.isDragging else { return }
        cell.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 0.3, animations: {
            cell.transform = CGAffineTransform.identity
        })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let message = messages?[indexPath.row] else { return }
        switch message.contentType {
        case .photo?:
            break
//            let vc: ImagePreviewController = UIStoryboard.controller(storyboard: .previews)
//            vc.imageURLString = message.profilePicLink
//            navigationController?.present(vc, animated: true)
        default: break
        }
    }
}

extension MessagesViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        showActionButtons(false)
        return true
    }
}

extension MessagesViewController: MessageTableViewCellDelegate {
    
    func messageTableViewCellUpdate() {
        messageTableView.beginUpdates()
        messageTableView.endUpdates()
    }
}
