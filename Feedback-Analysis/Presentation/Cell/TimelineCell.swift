import UIKit
import RxSwift
import RxCocoa

protocol CellTapDelegate {
    func tappedLikeBtn(index: Int)
}

final class TimelineCell: UITableViewCell {
    
    let disposeBag = DisposeBag()
    
    var delegate: CellTapDelegate?
    
    var identificationId = Int()
    
    private(set) var userPhoto: UIImageView = {
        let image = UIImageView.Builder()
            .cornerRadius(25)
            .isUserInteractionEnabled(false)
            .build()
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
    
    private(set) var genre1: UILabel = {
        let label = UILabel()
        label.apply(.body_CoolGrey)
        return label
    }()
    
    private(set) var genre2: UILabel = {
        let label = UILabel()
        label.apply(.body_CoolGrey)
        return label
    }()
    
    private(set) var newThingsTitle: UILabel = {
        let label = UILabel()
        label.apply(.body_CoolGrey13, title: "新しく始めたこと")
        return label
    }()
    
    private(set) var newThings: UILabel = {
        let label = UILabel()
        label.apply(.h5_appSub_bold)
        label.numberOfLines = 0
        return label
    }()
    
    private(set) var goalsTitle: UILabel = {
        let label = UILabel()
        label.apply(.body_CoolGrey13, title: "期待する成果")
        return label
    }()
    
    private(set) var goal1: UILabel = {
        let label = UILabel()
        label.apply(.h6_appSub_bold)
        label.numberOfLines = 0
        return label
    }()
    
    private(set) var goal2: UILabel = {
        let label = UILabel()
        label.apply(.h6_appSub_bold)
        label.numberOfLines = 0
        return label
    }()
    
    private(set) var goal3: UILabel = {
        let label = UILabel()
        label.apply(.h6_appSub_bold)
        label.numberOfLines = 0
        return label
    }()
    
    private(set) var deadLineTitle: UILabel = {
        let label = UILabel()
        label.apply(.body_CoolGrey13, title: "達成までの期限")
        return label
    }()
    
    private(set) var deadLine: UILabel = {
        let label = UILabel()
        label.apply(.h6_appSub_bold)
        return label
    }()
    
    private(set) var postContent: UILabel = {
        let label = UILabel()
        label.apply(.title)
        label.numberOfLines = 0
        return label
    }()
    
    private(set) var leftTopImage: UIImageView = {
        let image = UIImageView.Builder()
            .cornerRadius(10)
            .isUserInteractionEnabled(false)
            .build()
        image.layer.maskedCorners = [.layerMinXMinYCorner]
        return image
    }()
    
    private(set) var rightTopImage: UIImageView = {
        let image = UIImageView.Builder()
            .cornerRadius(10)
            .isUserInteractionEnabled(false)
            .build()
        image.layer.maskedCorners = [.layerMaxXMinYCorner]
        return image
    }()
    
    private(set) var leftBottomImage: UIImageView = {
        let image = UIImageView.Builder()
            .cornerRadius(10)
            .isUserInteractionEnabled(false)
            .build()
        image.layer.maskedCorners = [.layerMinXMaxYCorner]
        return image
    }()
    
    private(set) var rightBottomImage: UIImageView = {
        let image = UIImageView.Builder()
            .cornerRadius(10)
            .isUserInteractionEnabled(false)
            .build()
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
            .component(.body_CoolGrey16)
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
            .component(.body_CoolGrey16)
            .build()
        return button
    }()
    
    var content: Timeline! {
        didSet {
            userPhoto.setImage(url: content.userImage)
            userName.text = content.name
            postedTime.text = content.time
            setupGenres(content.genre1 ?? "", content.genre2 ?? "")
            newThings.text = content.newThings
            goal1.text = "1. \(String(describing: content.goal1 ?? ""))"
            goal2.text = "2. \(String(describing: content.goal2 ?? ""))"
            goal3.text = "3. \(String(describing: content.goal3 ?? ""))"
            deadLine.text = content.deadLine
            content.postImage?.count ?? 0 >= 1 ? adjustImagesSpace(images: content.postImage?.compactMap { UIImage(url:$0) }) : adjustImagesSpace(images: nil)
            commentCount.text = "\(content.commentedCount)"
            likeCount.text = "\(content.likeCount)"
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

extension TimelineCell {
    
    private func setup() {
        backgroundColor = .appMainColor
        bindUI()
        let lhsImageStack = UIStackView.setupStack(lhs: leftTopImage, rhs: rightTopImage, spacing: 5)
        let rhsImageStack = UIStackView.setupStack(lhs: leftBottomImage, rhs: rightBottomImage, spacing: 5)
        let imageStack = UIStackView.setupVerticalStack(lhs: lhsImageStack, rhs: rhsImageStack, spacing: 5)
        let commentStack = UIStackView.setupStack(lhs: commentBtn, rhs: commentCount, spacing: 5)
        let likeStack = UIStackView.setupStack(lhs: likeBtn, rhs: likeCount, spacing: 5)
        
        let genres = UIStackView(arrangedSubviews: [
            genre2,
            genre1
        ])
        genres.spacing = 5
        
        let newThingsStack = VerticalStackView(arrangeSubViews: [
            newThingsTitle,
            newThings
        ], spacing: 5)
        
        let goalsStack = VerticalStackView(arrangeSubViews: [
            goalsTitle,
            VerticalStackView(arrangeSubViews: [
                goal1,
                goal2,
                goal3
            ], spacing: 10)
        ], spacing: 5)
        
        let deadLineStack = VerticalStackView(arrangeSubViews: [
            deadLineTitle,
            deadLine
        ], spacing:  5)
        
        [userPhoto, userName, postedTime, genres,
         newThingsStack, goalsStack, deadLineStack,
         postContent, imageStack, commentStack, likeStack].forEach { addSubview($0) }
        
        [leftTopImage, rightTopImage, leftBottomImage, rightBottomImage].forEach {
            $0.anchor()
                .width(constant: (frame.width / 1.1) / 2.0 - 5.0)
                .height(constant: 70)
                .activate()
        }
        
        newThings.anchor()
            .width(to: widthAnchor, multiplier: 0.65)
            .activate()
        
        goal1.anchor()
            .width(to: widthAnchor, multiplier: 0.65)
            .activate()
        
        goal2.anchor()
            .width(to: widthAnchor, multiplier: 0.65)
            .activate()
        
        goal3.anchor()
            .width(to: widthAnchor, multiplier: 0.65)
            .activate()
        
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
        
        genres.anchor()
            .top(to: postedTime.bottomAnchor, constant: 5)
            .right(to: rightAnchor, constant: -20)
            .activate()
        
        newThingsStack.anchor()
            .top(to: genres.bottomAnchor, constant: 5)
            .left(to: userPhoto.rightAnchor, constant: 15)
            .activate()
        
        goalsStack.anchor()
            .top(to: newThingsStack.bottomAnchor, constant: 15)
            .left(to: newThingsStack.leftAnchor)
            .activate()
        
        deadLineStack.anchor()
            .top(to: goalsStack.bottomAnchor, constant: 15)
            .left(to: newThingsStack.leftAnchor)
            .activate()
        
        postContent.anchor()
            .top(to: deadLineStack.bottomAnchor, constant: 5)
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
            .top(to: imageStack.bottomAnchor, constant: 2)
            .left(to: userPhoto.rightAnchor, constant: 10)
            .bottom(to: bottomAnchor, constant: -5)
            .activate()

        likeStack.anchor()
            .top(to: imageStack.bottomAnchor, constant: 2)
            .left(to: commentStack.rightAnchor, constant: 20)
            .bottom(to: bottomAnchor, constant: -5)
            .activate()
    }
    
    private func setupGenres(_ genre1: String, _ genre2: String) {
        self.genre1.text = genre1
        self.genre2.text = genre2
    }
}

extension TimelineCell {
    
    func bindUI() {
        likeBtn.rx.tap.asDriver()
            .drive(onNext: { [unowned self] _ in
                self.delegate?.tappedLikeBtn(index: self.identificationId)
            }).disposed(by: disposeBag)
    }
}
