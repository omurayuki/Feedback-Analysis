import UIKit

protocol MessageTableViewCellDelegate: class {
    func messageTableViewCellUpdate()
}

class MessageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var messageProfilePic: UIImageView!
    @IBOutlet weak var messagesTextView: UITextView!
    
    //// String == ObjectMessage
    func set(_ message: Message) {
        print(message)
        messagesTextView?.text = message.message
        guard let imageView = messageProfilePic else { return }
        guard let userID = message.ownerID else { return }
        //// userId でprofile情報を取得
        UserEntityManager().fetchUserEntity(documentRef: .userRef(authorToken: userID)) { response in
            switch response {
            case .success(let entity):
                imageView.setImage(url: entity.userImage)
            case .failure(let error):
                print("エラー")
                print(error.localizedDescription)
            case .unknown:
                return
            }
        }
    }
}

class MessageAttachmentTableViewCell: MessageTableViewCell {
    
    @IBOutlet weak var messageAttachmentImageView: UIImageView! {
        didSet {
            messageAttachmentImageView.contentMode = .scaleAspectFill
        }
    }
    @IBOutlet weak var messageAttachmentImageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageAttachmentImageViewWidthConstraint: NSLayoutConstraint!
    
    weak var delegate: MessageTableViewCellDelegate?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        messageAttachmentImageView.cancelDownload()
        messageAttachmentImageView.image = nil
        messageAttachmentImageViewHeightConstraint.constant = 250 / 1.3
        messageAttachmentImageViewWidthConstraint.constant = 250
    }
    
    //// String == ObjectMessage
    override func set(_ message: Message) {
        super.set(message)
        switch message.contentType {
        case .photo:
            guard let urlString = message.profilePicLink else { return }
            messageAttachmentImageView.setImage(url: URL(string: urlString)) {[weak self] image in
                guard let image = image, let weakSelf = self else { return }
                guard weakSelf.messageAttachmentImageViewHeightConstraint.constant != image.size.height, weakSelf.messageAttachmentImageViewWidthConstraint.constant != image.size.width else { return }
                if max(image.size.height, image.size.width) <= 250 {
                    weakSelf.messageAttachmentImageViewHeightConstraint.constant = image.size.height
                    weakSelf.messageAttachmentImageViewWidthConstraint.constant = image.size.width
                    weakSelf.delegate?.messageTableViewCellUpdate()
                    return
                }
                weakSelf.messageAttachmentImageViewWidthConstraint.constant = 250
                weakSelf.messageAttachmentImageViewHeightConstraint.constant = image.size.height * (250 / image.size.width)
                weakSelf.delegate?.messageTableViewCellUpdate()
            }
        default: break
        }
    }
}
