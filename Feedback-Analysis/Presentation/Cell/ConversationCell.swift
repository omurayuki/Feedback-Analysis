import UIKit

final class ConversationCell: UITableViewCell {
    
    private(set) var userPhoto: UIImageView = {
        let image = UIImageView.Builder()
            .cornerRadius(25)
            .isUserInteractionEnabled(false)
            .build()
        return image
    }()
    
    private(set) var userName: UILabel = {
        let label = UILabel()
        label.apply(.h4)
        return label
    }()
    
    private(set) var time: UILabel = {
        let label = UILabel()
        label.apply(.body_CoolGrey)
        return label
    }()
    
    private(set) var attributeMessage: UILabel = {
        let label = UILabel()
        label.apply(.body_CoolGrey13)
        return label
    }()
    
    var content: Conversation? {
        didSet {
            let userID = AppUserDefaults.getAuthToken()
            time.text = content?.timestamp.offsetFrom()
            attributeMessage.text = content?.lastMessage
            guard let id = content?.userIDs.filter({$0 != userID}).first else { return }
            let isRead = content?.isRead[userID] ?? true
            if !isRead {
                userName.font = userName.font.bold
                attributeMessage.font = attributeMessage.font.bold
                time.font = time.font.bold
            } else {
                userName.apply(.h4)
                time.apply(.body_darkGray)
                attributeMessage.apply(.body_darkGray13)
            }
            UserEntityManager().fetchUserEntity(documentRef: .userRef(authorToken: id)) { response in
                switch response {
                case .success(let entity):
                    self.userName.text = entity.name
                    self.userPhoto.setImage(url: entity.userImage)
                case .failure(_):
                    return
                case .unknown:
                    return
                }
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}

extension ConversationCell {
    
    private func setup() {
        backgroundColor = .appMainColor
        [userPhoto, userName, time, attributeMessage].forEach { addSubview($0) }
        
        userPhoto.anchor()
            .top(to: topAnchor, constant: 10)
            .left(to: leftAnchor, constant: 20)
            .bottom(to: bottomAnchor, constant: -15)
            .width(constant: 50)
            .height(constant: 50)
            .activate()
        
        userName.anchor()
            .top(to: topAnchor, constant: 5)
            .left(to: userPhoto.rightAnchor, constant: 15)
            .activate()
        
        time.anchor()
            .top(to: topAnchor, constant: 5)
            .right(to: rightAnchor, constant: -20)
            .activate()
        
        attributeMessage.anchor()
            .top(to: userName.bottomAnchor, constant: 5)
            .left(to: userPhoto.rightAnchor, constant: 15)
            .width(constant: frame.width / 1.7)
            .activate()
    }
}
