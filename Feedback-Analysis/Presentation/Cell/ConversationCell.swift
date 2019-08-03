import UIKit

final class ConversationCell: UITableViewCell {
    
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
        label.apply(.h4_Bold, title: "オムラユウキ")
        return label
    }()
    
    private(set) var time: UILabel = {
        let label = UILabel()
        label.apply(.body_CoolGrey, title: "10:10")
        return label
    }()
    
    private(set) var attributeMessage: UILabel = {
        let label = UILabel()
        label.apply(.body_CoolGrey13, title: "hogehogehogehogehogehogehogehogehoge")
        return label
    }()
    
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
            .top(to: topAnchor, constant: 5)
            .left(to: leftAnchor, constant: 20)
            .bottom(to: bottomAnchor, constant: -5)
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
