import UIKit

internal enum FollowState {
    case following
    case nonFollowing
}

class FollowButton: UIButton {
    
    private var follow = "   フォローする   "
    private var duringFollow = "     フォロー中     "
    
    var currentState: FollowState = .nonFollowing {
        didSet {
            UIView.Animator(duration: 0.3, delay: 0, options: .curveEaseInOut)
                .animations { self.setup() }
                .completion { _ in }
                .animate()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
}

extension FollowButton {
    
    private func setup() {
        switch currentState {
        case .nonFollowing:   layoutBtn(name: follow, mainColor: .appSubColor, subColor: .appMainColor)
        case .following:      layoutBtn(name: duringFollow, mainColor: .appMainColor, subColor: .appSubColor)
        }
    }
    
    private func layoutBtn(name: String, mainColor: UIColor, subColor: UIColor) {
        setTitle(name, for: .normal)
        setTitleColor(mainColor, for: .normal)
        backgroundColor = subColor
        layer.masksToBounds = true
        layer.cornerRadius = 15
        layer.borderColor = mainColor.cgColor
        layer.borderWidth = 1
        titleLabel?.font = .boldSystemFont(ofSize: 15)
        isUserInteractionEnabled = true
    }
}
