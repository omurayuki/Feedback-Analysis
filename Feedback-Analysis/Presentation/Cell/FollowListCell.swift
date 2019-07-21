import UIKit

final class FollowListCell: UITableViewCell {
    
    private(set) var userPhoto: UIImageView = {
        let image = UIImageView.Builder()
            .cornerRadius(25)
            .backgroundColor(.green)
            .isUserInteractionEnabled(false)
            .build()
        return image
    }()
    
    private(set) var userName: UILabel = {
        let label = UILabel()
        label.apply(.h4_Bold)
        return label
    }()
    
    private(set) var contentField: UILabel = {
        let label = UILabel()
        label.apply(.title)
        label.numberOfLines = 0
        return label
    }()
    
    var content: User? {
        didSet {
            guard let url = content?.userImage else { return }
            userPhoto.setImage(url: url)
            userName.text = content?.name
            contentField.text = content?.content
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

extension FollowListCell {
    
    private func setup() {
        backgroundColor = .appMainColor
        [userPhoto, userName, contentField].forEach { addSubview($0) }
        
        userPhoto.anchor()
            .top(to: topAnchor, constant: 5)
            .left(to: leftAnchor, constant: 20)
            .width(constant: 50)
            .height(constant: 50)
            .activate()
        
        userName.anchor()
            .centerY(to: userPhoto.centerYAnchor)
            .left(to: userPhoto.rightAnchor, constant: 25)
            .activate()
        
        contentField.anchor()
            .top(to: userPhoto.bottomAnchor, constant: 5)
            .left(to: leftAnchor, constant: 20)
            .right(to: rightAnchor, constant: -20)
            .width(constant: frame.width / 1.1)
            .bottom(to: bottomAnchor, constant: -5)
            .activate()
    }
}
