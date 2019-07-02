import UIKit

final class CommentCell: UITableViewCell {
    
    private(set) var userPhoto: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .blue
        image.layer.cornerRadius = 25
        image.layer.borderWidth = 2
        image.layer.borderColor = UIColor.white.cgColor
        image.image = #imageLiteral(resourceName: "logo")
        image.clipsToBounds = true
        return image
    }()
    
    private(set) var userName: UILabel = {
        let label = UILabel()
        label.apply(.h4_Bold)
        return label
    }()
    
    private(set) var postedTime: UILabel = {
        let label = UILabel()
        label.apply(.body_CoolGrey)
        return label
    }()
    
    private(set) var comment: UILabel = {
        let label = UILabel()
        label.apply(.title)
        label.numberOfLines = 0
        return label
    }()
    
    private(set) var repliedCount: UILabel = {
        let label = UILabel()
        label.apply(.title_Bold)
        return label
    }()
    
    private(set) var commentBtn: UIButton = {
        let button = UIButton.Builder()
            .title("✎")
            .component(.body_CoolGrey13)
            .build()
        return button
    }()
    
    private(set) var likeCount: UILabel = {
        let label = UILabel()
        label.apply(.title_Bold)
        return label
    }()
    
    private(set) var likeBtn: UIButton = {
        let button = UIButton.Builder()
            .title("♡")
            .component(.body_CoolGrey13)
            .build()
        return button
    }()
    
    var content: Comment? {
        didSet {
            guard let url = content?.userImage else { return }
            guard let repliedCount = content?.repliedCount else { return }
            guard let likeCount = content?.likeCount else { return }
            self.userName.text = content?.name
            self.comment.text = content?.comment
            self.userPhoto.setImage(url: url)
            self.repliedCount.text = "\(repliedCount)"
            self.likeCount.text = "\(likeCount)"
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

extension CommentCell {
    private func setup() {
        backgroundColor = .appMainColor
        
        let commentStack = UIStackView.setupStack(lhs: commentBtn, rhs: repliedCount, spacing: 5)
        let likeStack = UIStackView.setupStack(lhs: likeBtn, rhs: likeCount, spacing: 5)
        
        [userPhoto, userName, postedTime,
         comment, commentStack, likeStack].forEach { addSubview($0) }
        
        userPhoto.anchor()
            .top(to: topAnchor, constant: 5)
            .left(to: leftAnchor, constant: 20)
            .width(constant: 50)
            .height(constant: 50)
            .activate()
        
        userName.anchor()
            .top(to: topAnchor, constant: 10)
            .left(to: userPhoto.rightAnchor, constant: 15)
            .activate()
        
        postedTime.anchor()
            .top(to: topAnchor, constant: 10)
            .right(to: rightAnchor, constant: -20)
            .activate()
        
        comment.anchor()
            .top(to: userName.bottomAnchor, constant: 5)
            .left(to: userPhoto.rightAnchor, constant: 10)
            .right(to: rightAnchor, constant: -20)
            .width(constant: frame.width / 1.1)
            .activate()
        
        commentStack.anchor()
            .top(to: comment.bottomAnchor, constant: 5)
            .left(to: userPhoto.rightAnchor, constant: 10)
            .bottom(to: bottomAnchor)
            .activate()
        
        likeStack.anchor()
            .top(to: comment.bottomAnchor, constant: 5)
            .left(to: commentStack.rightAnchor, constant: 20)
            .bottom(to: bottomAnchor)
            .activate()
    }
}
