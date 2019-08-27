import Foundation
import UIKit
import RxSwift
import RxCocoa

class MessagesViewController: UIViewController {
    
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var messageInputTextField: UITextField!
    @IBOutlet weak var messageExpandButton: UIButton!
    @IBOutlet weak var messageBarBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageStackViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageSendButton: UIButton! {
        didSet {
            messageSendButton.tintColor = .appSubColor
        }
    }
    @IBOutlet var messageActionButtons: [UIButton]! {
        didSet {
            messageActionButtons.forEach { $0.tintColor = .appSubColor }
        }
    }
    private(set) var viewTapGesture = UITapGestureRecognizer()
    
    var messages: [Message]? {
        didSet {
            messageTableView.reloadData()
            messageTableView.scroll(to: .bottom, animated: true)
        }
    }
    
    var bottomInset: CGFloat {
        return view.safeAreaInsets.bottom + 50
    }
    
    private let manager = MessageManager()
    private let imageService = ImagePickerService()
    
    var presenter: MessagesPresenter! {
        didSet {
            presenter.view = self
        }
    }
    
    var routing: MessagesRouting!
    
    func inject(presenter: MessagesPresenter,
                routing: MessagesRouting) {
        self.presenter = presenter
        self.routing = routing
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addKeyboard()
        messageInputTextField.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bindUI()
    }
}

extension MessagesViewController: MessagesPresenterView {
    
    func didFetchMessages(messages: [Message]) {
        self.messages = messages
    }
}

extension MessagesViewController {
    
    func recieve(conversation: Conversation) {
        presenter.conversation = conversation
        presenter.fetchMessages(queryRef: .messagesRef(conversationId: conversation.id))
        presenter.getAuthToken { [unowned self] subjectToken in
            self.presenter.subjectToken = subjectToken
        }
    }
    
    private func bindUI() {
        messageExpandButton.rx.tap.asDriver()
            .drive(onNext: { [unowned self] _ in
                self.showActionButtons(true)
            }).disposed(by: presenter.disposeBag)
        
        messageActionButtons.forEach { value in
            value.rx.tap.asDriver()
                .drive(onNext: { [unowned self] _ in
                    self.imageService.pickImage(from: self, allowEditing: false, source: value.tag == 0 ? .photoLibrary : .photoLibrary) { [unowned self] image in
                        let message = Message(contentType: .photo, profilePic: image, ownerID: self.presenter.subjectToken)
                        self.send(message)
                        self.messageInputTextField.text = nil
                        self.showActionButtons(false)
                    }
                }).disposed(by: presenter.disposeBag)
        }
        
        messageSendButton.rx.tap.asDriver()
            .drive(onNext: { [unowned self] _ in
                guard let text = self.messageInputTextField.text, !text.isEmpty else { return }
                let message = Message(message: text, ownerID: self.presenter.subjectToken)
                self.messageInputTextField.text = nil
                self.showActionButtons(false)
                self.send(message)
            }).disposed(by: presenter.disposeBag)
        
        messageInputTextField.rx.controlEvent(.editingDidBegin).asDriver()
            .drive(onNext: { [unowned self] _ in
                self.showActionButtons(false)
            }).disposed(by: presenter.disposeBag)
    }
    
    private func send(_ message: Message) {
        #warning("presenterに移動")
        guard let conversation = presenter.conversation else { return }
        manager.create(documentRef: .messageRef(conversationID: conversation.id, messageID: message.id), message: message, conversation: conversation) { response in
            switch response {
            //// updateされた後のconversationでなければ、isReadの値が引き継がれない
            case .success(var updatedConversation):
                updatedConversation.timestamp = Date(timeIntervalSince1970: Date().timeIntervalSince1970)
                switch message.contentType {
                case .none: updatedConversation.lastMessage = message.message
                case .photo: updatedConversation.lastMessage = "Attachment"
                default: break
                }
                updatedConversation.isRead[self.presenter.subjectToken] = true
                ConversationManager().create(documentRef: .conversationRef(conversationID: updatedConversation.id), conversation: updatedConversation,
                                             completion: { response in
                    switch response {
                    case .success(_):
                        return
                    case .failure(let error):
                        self.showError(message: error.localizedDescription)
                    case .unknown:
                        return
                    }
                })
            case .failure(let error):
                self.showError(message: error.localizedDescription)
            case .unknown:
                return
            }
        }
    }
    
    private func showActionButtons(_ status: Bool) {
        guard !status else {
            messageStackViewWidthConstraint.constant = 75
            UIView.animate(withDuration: 0.3) {
                self.messageExpandButton.isHidden = true
                self.messageExpandButton.alpha = 0
                self.messageActionButtons.forEach({ $0.isHidden = false })
                self.view.layoutIfNeeded()
            }
            return
        }
        guard messageStackViewWidthConstraint.constant != 25 else { return }
        messageStackViewWidthConstraint.constant = 25
        UIView.animate(withDuration: 0.2) {
            self.messageExpandButton.isHidden = false
            self.messageExpandButton.alpha = 1
            self.messageActionButtons.forEach({ $0.isHidden = true })
            self.view.layoutIfNeeded()
        }
    }
    
    func addKeyboard() {
        addKeyboardObservers() {[unowned self] state in
            guard state else { return }
            self.messageTableView.scroll(to: .bottom, animated: true)
        }
    }
}

extension MessagesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let message = messages?[indexPath.row] else { return UITableViewCell() }
        if message.contentType == ContentType.none {
            let cell = tableView.dequeueReusableCell(withIdentifier: message.ownerID == presenter.subjectToken ? "MessageTableViewCell" : "UserMessageTableViewCell") as! MessageTableViewCell
            cell.set(message)
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: message.ownerID == presenter.subjectToken ? "MessageAttachmentTableViewCell" : "UserMessageAttachmentTableViewCell") as! MessageAttachmentTableViewCell
        cell.set(message)
        return cell
    }
}

extension MessagesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let message = messages?[indexPath.row] else { return }
        switch message.contentType {
        case .photo:
            guard let imageLink = message.profilePicLink else { return }
            routing.showPreviewPage(imageLink: imageLink)
        default: break
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard tableView.isDragging else { return }
        cell.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 0.3, animations: {
            cell.transform = CGAffineTransform.identity
        })
    }
}

extension MessagesViewController: KeyboardHandler {}

extension MessagesViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
