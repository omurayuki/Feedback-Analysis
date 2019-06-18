import UIKit

class TimelineCell: UITableViewCell {
    
    private(set) var contentWrap: UIView = {
        let view = UIView()
        return view
    }()
    
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
    
    private(set) var postContent: UILabel = {
        let label = UILabel()
        label.apply(.title)
        label.numberOfLines = 0
        return label
    }()
    
    private(set) var leftTopImage: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 10
        image.layer.maskedCorners = [.layerMinXMinYCorner]
        return image
    }()
    
    private(set) var rightTopImage: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 10
        image.layer.maskedCorners = [.layerMaxXMinYCorner]
        return image
    }()
    
    private(set) var leftBottomImage: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 10
        image.layer.maskedCorners = [.layerMinXMaxYCorner]
        return image
    }()
    
    private(set) var rightBottomImage: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 10
        image.layer.maskedCorners = [.layerMaxXMaxYCorner]
        return image
    }()
    
    private(set) var commentCount: UILabel = {
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}

extension TimelineCell {
    
    private func setup() {
        backgroundColor = .appMainColor
        
        let lhsImageStack = UIStackView.setupStack(lhs: leftTopImage, rhs: rightTopImage, spacing: 5)
        let rhsImageStack = UIStackView.setupStack(lhs: leftBottomImage, rhs: rightBottomImage, spacing: 5)
        let imageStack = UIStackView.setupVerticalStack(lhs: lhsImageStack, rhs: rhsImageStack, spacing: 5)
        let commentStack = UIStackView.setupStack(lhs: commentBtn, rhs: commentCount, spacing: 5)
        let likeStack = UIStackView.setupStack(lhs: likeBtn, rhs: likeCount, spacing: 5)
        
        [userPhoto, userName, postedTime, postContent, imageStack, commentStack, likeStack].forEach { addSubview($0) }
        
        [leftTopImage, rightTopImage, leftBottomImage, rightBottomImage].forEach {
            $0.anchor()
                .width(constant: (frame.width / 1.1) / 2.0 - 5.0)
                .height(constant: 70)
                .activate()
        }
        
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
        
        postContent.anchor()
            .top(to: userName.bottomAnchor, constant: 10)
            .left(to: userPhoto.rightAnchor, constant: 10)
            .right(to: rightAnchor, constant: -20)
            .width(constant: frame.width / 1.1)
            .activate()

        imageStack.anchor()
            .top(to: postContent.bottomAnchor, constant: 15)
            .left(to: userPhoto.rightAnchor, constant: 10)
            .right(to: rightAnchor, constant: -20)
            .activate()

        commentStack.anchor()
            .top(to: imageStack.bottomAnchor, constant: 5)
            .left(to: userPhoto.rightAnchor, constant: 10)
            .bottom(to: bottomAnchor)
            .activate()

        likeStack.anchor()
            .top(to: imageStack.bottomAnchor, constant: 5)
            .left(to: commentStack.rightAnchor, constant: 20)
            .bottom(to: bottomAnchor)
            .activate()
    }
    
    func configure(photo: UIImage,
                   name: String, time: String,
                   content: String, postImage: [UIImage]?,
                   commentted: String, like: String) {
        userPhoto.image = photo
        userName.text = name
        postedTime.text = time
        postContent.text = content
        postImage?.count ?? 0 >= 1 ? adjustImagesSpace(images: postImage) : adjustImagesSpace(images: nil)
        commentCount.text = commentted
        likeCount.text = like
    }
}
