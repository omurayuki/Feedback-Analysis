import UIKit
import RxSwift
import RxCocoa

final class CommentCell: UITableViewCell {
    
    let disposeBag = DisposeBag()
    
    var cellTapDelegate: CellTapDelegate?
    
    var userPhotoTapDelegate: UserPhotoTapDelegate?
    
    var identificationId = Int()
    
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
            self.postedTime.text = content?.time
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
        bindUI()
        let commentStack = UIStackView.setupStack(lhs: commentBtn, rhs: repliedCount, spacing: 5)
        let likeStack = UIStackView.setupStack(lhs: likeBtn, rhs: likeCount, spacing: 5)
        
        [userPhoto, userName, postedTime,
         comment, commentStack, likeStack].forEach { addSubview($0) }
        
        userPhoto.addGestureRecognizer(userPhotoGesture)
        
        userPhoto.anchor()
            .top(to: topAnchor, constant: 5)
            .left(to: leftAnchor, constant: 20)
            .width(constant: 50)
            .height(constant: 50)
            .activate()
        
        userName.anchor()
            .top(to: topAnchor, constant: 10)
            .left(to: userPhoto.rightAnchor, constant: 15)
            .width(constant: frame.width / 1.8)
            .height(constant: 18)
            .activate()
        
        postedTime.anchor()
            .top(to: topAnchor, constant: 10)
            .right(to: rightAnchor, constant: -20)
            .activate()
        
        comment.anchor()
            .top(to: userName.bottomAnchor, constant: 5)
            .left(to: userPhoto.rightAnchor, constant: 10)
            .right(to: rightAnchor, constant: -10)
            .width(constant: frame.width / 1.1)
            .activate()
        
        commentStack.anchor()
            .top(to: comment.bottomAnchor, constant: 2)
            .left(to: userPhoto.rightAnchor, constant: 10)
            .bottom(to: bottomAnchor, constant: -5)
            .activate()
        
        likeStack.anchor()
            .top(to: comment.bottomAnchor, constant: 2)
            .left(to: commentStack.rightAnchor, constant: 20)
            .bottom(to: bottomAnchor, constant: -5)
            .activate()
    }
}

extension CommentCell {
    
    func bindUI() {
        likeBtn.rx.tap.asDriver()
            .drive(onNext: { [unowned self] _ in
                self.cellTapDelegate?.tappedLikeBtn(index: self.identificationId)
            }).disposed(by: disposeBag)
        
        userPhotoGesture.rx.event.asDriver()
            .drive(onNext: { [unowned self] _ in
                self.userPhotoTapDelegate?.tappedUserPhoto(index: self.identificationId)
            }).disposed(by: disposeBag)
    }
}
