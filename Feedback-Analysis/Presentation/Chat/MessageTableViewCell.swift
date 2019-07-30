import UIKit

protocol MessageTableViewCellDelegate: class {
    func messageTableViewCellUpdate()
}

class MessageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var messageProfilePic: UIImageView!
    @IBOutlet weak var messagesTextView: UITextView!
    
    //// String == ObjectMessage
    func set(_ message: String) {
//        messageTextView?.text = message.message
        guard let imageView = messageProfilePic else { return }
//        guard let userID = message.ownerID else { return }
//        ProfileManager.shared.userData(id: userID) { user in
//            guard let urlString = user?.profilePicLink else { return }
//            imageView.setImage(url: URL(string: urlString))
//        }
    }
}

class MessageAttachmentTableViewCell: MessageTableViewCell {
    
    @IBOutlet weak var messageAttachmentImageView: UIImageView!
    @IBOutlet weak var messageAttachmentImageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageAttachmentImageViewWidthConstraint: NSLayoutConstraint!
    
    
//    @IBOutlet weak var messageAttachmentImageView: UIImageView!
//    @IBOutlet weak var messageAttachmentImageViewHeightConstraint: NSLayoutConstraint!
//    @IBOutlet weak var messageAttachmentImageViewWidthConstraint: NSLayoutConstraint!
    weak var delegate: MessageTableViewCellDelegate?
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        attachmentImageView.cancelDownload()
        messageAttachmentImageView.image = nil
        messageAttachmentImageViewHeightConstraint.constant = 250 / 1.3
        messageAttachmentImageViewWidthConstraint.constant = 250
    }
    
    //// String == ObjectMessage
    override func set(_ message: String) {
        super.set(message)
//        switch message.contentType {
//        case .location:
//            attachmentImageView.image = UIImage(named: "locationThumbnail")
//        case .photo:
//            guard let urlString = message.profilePicLink else { return }
//            attachmentImageView.setImage(url: URL(string: urlString)) {[weak self] image in
//                guard let image = image, let weakSelf = self else { return }
//                guard weakSelf.attachmentImageViewHeightConstraint.constant != image.size.height, weakSelf.attachmentImageViewWidthConstraint.constant != image.size.width else { return }
//                if max(image.size.height, image.size.width) <= 250 {
//                    weakSelf.attachmentImageViewHeightConstraint.constant = image.size.height
//                    weakSelf.attachmentImageViewWidthConstraint.constant = image.size.width
//                    weakSelf.delegate?.messageTableViewCellUpdate()
//                    return
//                }
//                weakSelf.attachmentImageViewWidthConstraint.constant = 250
//                weakSelf.attachmentImageViewHeightConstraint.constant = image.size.height * (250 / image.size.width)
//                weakSelf.delegate?.messageTableViewCellUpdate()
//            }
//        default: break
//        }
    }
}
