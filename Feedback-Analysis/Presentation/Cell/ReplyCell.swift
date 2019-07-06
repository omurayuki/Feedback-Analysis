import UIKit

final class ReplyCell: UITableViewCell {
    
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
    
    private(set) var reply: UILabel = {
        let label = UILabel()
        label.apply(.title)
        label.numberOfLines = 0
        return label
    }()
    
    var content: Reply? {
        didSet {
            guard let url = content?.userImage else { return }
            self.userName.text = content?.name
            self.reply.text = content?.reply
            self.userPhoto.setImage(url: url)
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

extension ReplyCell {
    private func setup() {
        backgroundColor = .appMainColor
        
        [userPhoto, userName,
         postedTime, reply].forEach { addSubview($0) }
        
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
        
        reply.anchor()
            .top(to: userName.bottomAnchor, constant: 5)
            .left(to: userPhoto.rightAnchor, constant: 10)
            .bottom(to: bottomAnchor, constant: -10)
            .right(to: rightAnchor, constant: -10)
            .width(constant: frame.width / 1.1)
            .activate()
    }
}
