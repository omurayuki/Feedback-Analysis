import UIKit

protocol MypageUI: UI {
    var headerImage: UIImageView { get }
    var userImage: UIImageView { get }
    var userName: UILabel { get }
    var editBtn: UIButton { get }
    var contentField: UILabel { get }
    var residence: UILabel { get }
    var residenceField: UILabel { get }
    var birthDay: UILabel { get }
    var birthDayField: UILabel { get }
    var followCount: UILabel { get }
    var follow: UILabel { get }
    var followerCount: UILabel { get }
    var follower: UILabel { get }
    var timelineSegmented: CustomSegmentedControl { get }
    var timelineTable: UITableView { get }
    
    func setup()
    func updateUser(user: User)
}

final class MypageUIImpl: MypageUI {
    
    weak var viewController: UIViewController?
    
    private(set) var headerImage: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    private(set) var userImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 30
        image.layer.borderWidth = 2
        image.layer.borderColor = UIColor.white.cgColor
        image.backgroundColor = .white
        image.clipsToBounds = true
        return image
    }()
    
    private(set) var userName: UILabel = {
        let label = UILabel()
        label.apply(.h2_Bold)
        return label
    }()
    
    private(set) var editBtn: UIButton = {
        let button = UIButton.Builder()
            .title("   変更   ")
            .border(width: 1, color: UIColor.appMainColor.cgColor)
            .cornerRadius(15)
            .backgroundColor(.clear)
            .component(.appMain)
            .build()
        return button
    }()
    
    private(set) var contentField: UILabel = {
        let label = UILabel()
        label.apply(.title)
        label.numberOfLines = 0
        return label
    }()
    
    private(set) var residence: UILabel = {
        let label = UILabel()
        label.apply(.body_CoolGrey, title: "✺ 居住地")
        return label
    }()
    
    private(set) var residenceField: UILabel = {
        let label = UILabel()
        label.apply(.body_CoolGrey)
        return label
    }()
    
    private(set) var birthDay: UILabel = {
        let label = UILabel()
        label.apply(.body_CoolGrey, title: "✺ 誕生日")
        return label
    }()
    
    private(set) var birthDayField: UILabel = {
        let label = UILabel()
        label.apply(.body_CoolGrey)
        return label
    }()
    
    private(set) var followCount: UILabel = {
        let label = UILabel()
        label.apply(.body_Bold, title: "0")
        return label
    }()
    
    private(set) var follow: UILabel = {
        let label = UILabel()
        label.apply(.body_CoolGrey, title: "フォロー中")
        return label
    }()
    
    private(set) var followerCount: UILabel = {
        let label = UILabel()
        label.apply(.body_Bold, title: "0")
        return label
    }()
    
    private(set) var follower: UILabel = {
        let label = UILabel()
        label.apply(.body_CoolGrey, title: "フォロワー")
        return label
    }()
    
    private(set) var timelineSegmented: CustomSegmentedControl = {
        let segment = CustomSegmentedControl(frame: CGRect(), buttonTitle: ["目標", "達成", "いいね"])
        segment.backgroundColor = .clear
        return segment
    }()
    
    private(set) var timelineTable: UITableView = {
        let table = UITableView()
        table.estimatedRowHeight = 400
        table.rowHeight = UITableView.automaticDimension
        table.register(TimelineCell.self, forCellReuseIdentifier: String(describing: TimelineCell.self))
        return table
    }()
}

extension MypageUIImpl {
    func setup() {
        guard let vc = viewController else { return }
        vc.view.backgroundColor = .white
        vc.clearNavBar()
        
        let residenceStack = UIStackView.setupStack(lhs: residence, rhs: residenceField, spacing: 5)
        let birthStack = UIStackView.setupStack(lhs: birthDay, rhs: birthDayField, spacing: 5)
        let followStack = UIStackView.setupStack(lhs: followCount, rhs: follow, spacing: 5)
        let followerStack = UIStackView.setupStack(lhs: followerCount, rhs: follower, spacing: 5)
        
        [headerImage, userImage, userName,
         editBtn, contentField, residenceStack,
         birthStack, followStack, followerStack,
         timelineSegmented, timelineTable].forEach { vc.view.addSubview($0) }
        
        headerImage.anchor()
            .top(to: vc.view.topAnchor)
            .width(to: vc.view.widthAnchor)
            .height(to: vc.view.heightAnchor, multiplier: 0.15)
            .activate()
        
        userImage.anchor()
            .top(to: headerImage.bottomAnchor, constant: -20)
            .left(to: vc.view.leftAnchor, constant: 20)
            .width(constant: 60)
            .height(constant: 60)
            .activate()
        
        userName.anchor()
            .top(to: userImage.bottomAnchor, constant: 10)
            .left(to: vc.view.leftAnchor, constant: 20)
            .activate()
        
        editBtn.anchor()
            .top(to: headerImage.bottomAnchor, constant: 10)
            .right(to: vc.view.rightAnchor, constant: -20)
            .activate()
        
        contentField.anchor()
            .top(to: userName.bottomAnchor, constant: 10)
            .left(to: vc.view.leftAnchor, constant: 20)
            .right(to: vc.view.rightAnchor, constant: -20)
            .activate()
        
        residenceStack.anchor()
            .top(to: contentField.bottomAnchor, constant: 10)
            .left(to: vc.view.leftAnchor, constant: 20)
            .activate()
        
        birthStack.anchor()
            .top(to: contentField.bottomAnchor, constant: 10)
            .left(to: residenceStack.rightAnchor, constant: 15)
            .activate()
        
        followStack.anchor()
            .top(to: residenceStack.bottomAnchor, constant: 10)
            .left(to: vc.view.leftAnchor, constant: 20)
            .activate()
        
        followerStack.anchor()
            .top(to: residenceStack.bottomAnchor, constant: 10)
            .left(to: followStack.rightAnchor, constant: 15)
            .activate()
        
        timelineSegmented.anchor()
            .centerXToSuperview()
            .top(to: followerStack.bottomAnchor, constant: 5)
            .width(to: vc.view.widthAnchor, multiplier: 0.95)
            .height(constant: 35)
            .activate()
        
        timelineTable.anchor()
            .top(to: timelineSegmented.bottomAnchor, constant: 2)
            .width(to: vc.view.widthAnchor)
            .height(to: vc.view.heightAnchor, multiplier: 0.5)
            .activate()
    }
    
    func updateUser(user: User) {
        headerImage.setImage(url: user.headerImage)
        userImage.setImage(url: user.userImage)
        userName.text = user.name
        contentField.text = user.content
        birthDayField.text = user.birth
        residenceField.text = user.residence
        followCount.text = String(user.follow)
        followerCount.text = String(user.follower)
    }
}
