import UIKit

final class TimelineView: UIView {
    
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
    
    private(set) var borderBottom: UIView = {
        let view = UIView()
        view.backgroundColor = .appSubColor
        return view
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

extension TimelineView {
    
    private func setup() {
        backgroundColor = .appMainColor
        
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
         postContent, borderBottom].forEach { addSubview($0) }
        
        userPhoto.addGestureRecognizer(userPhotoGesture)
        
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
            .top(to: topAnchor, constant: 10)
            .left(to: leftAnchor, constant: 20)
            .width(constant: 50)
            .height(constant: 50)
            .activate()
        
        userName.anchor()
            .top(to: topAnchor, constant: 15)
            .left(to: leftAnchor, constant: 85)
            .height(constant: 15)
            .activate()
        
        postedTime.anchor()
            .top(to: userName.topAnchor)
            .right(to: rightAnchor, constant: -20)
            .activate()
        
        genres.anchor()
            .top(to: postedTime.bottomAnchor, constant: 5)
            .right(to: rightAnchor, constant: -20)
            .activate()
        
        newThingsStack.anchor()
            .top(to: userName.bottomAnchor, constant: 35)
            .left(to: leftAnchor, constant: 85)
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
            .left(to: leftAnchor, constant: 80)
            .right(to: rightAnchor, constant: -20)
            .bottom(to: bottomAnchor, constant: -20)
            .width(constant: frame.width / 1.1)
            .activate()
        
        borderBottom.anchor()
            .bottom(to: bottomAnchor)
            .width(to: widthAnchor)
            .height(constant: 0.5)
            .activate()
    }
    
    private func setupGenres(_ genre1: String, _ genre2: String) {
        self.genre1.text = genre1
        self.genre2.text = genre2
    }
}
