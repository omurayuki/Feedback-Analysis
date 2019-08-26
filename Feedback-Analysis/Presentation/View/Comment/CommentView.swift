import UIKit

final class CommentView: UIView {
    
    private(set) var userPhoto: UIImageView = {
        let image = UIImageView.Builder()
            .cornerRadius(25)
            .build()
        return image
    }()
    
    private(set) var userPhotoGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        return gesture
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
    
    private(set) var borderBottom: UIView = {
        let view = UIView()
        view.backgroundColor = .appSubColor
        return view
    }()
    
    var content: Comment? {
        didSet {
            guard let url = content?.userImage else { return }
            self.userName.text = content?.name
            self.postedTime.text = content?.time
            self.comment.text = content?.comment
            self.userPhoto.setImage(url: url)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}

extension CommentView {
    
    private func setup() {
        backgroundColor = .appMainColor
        [userPhoto, userName, postedTime, comment, borderBottom].forEach { addSubview($0) }
        
        userPhoto.addGestureRecognizer(userPhotoGesture)
        
        userPhoto.anchor()
            .top(to: topAnchor, constant: 5)
            .left(to: leftAnchor, constant: 20)
            .width(constant: 50)
            .height(constant: 50)
            .activate()
        
        userName.anchor()
            .top(to: topAnchor, constant: 10)
            .left(to: leftAnchor, constant: 85)
            .height(constant: 18)
            .activate()
        
        postedTime.anchor()
            .top(to: topAnchor, constant: 10)
            .right(to: rightAnchor, constant: -20)
            .activate()
        
        comment.anchor()
            .top(to: userName.bottomAnchor, constant: 5)
            .left(to: leftAnchor, constant: 80)
            .right(to: rightAnchor, constant: -10)
            .activate()
        
        borderBottom.anchor()
            .bottom(to: bottomAnchor)
            .width(to: widthAnchor)
            .height(constant: 0.5)
            .activate()
    }
}

