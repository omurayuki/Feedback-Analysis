import UIKit

protocol TopUI: UI {
    var iconWrapView: UIView { get }
    var icon: UIImageView { get }
    var loginBtn: UIButton { get }
    var signupBtn: UIButton { get }
    
    func setup()
}

final class TopUIImpl: TopUI {
    
    weak var viewController: UIViewController?
    
    private(set) var iconWrapView: UIView = {
        let view = UIView()
        return view
    }()
    
    private(set) var icon: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "logo_non_title")
        return image
    }()
    
    private(set) var loginBtn: UIButton = {
        let button = UIButton.Builder()
            .title("ログイン")
            .component(.title_White)
            .backgroundColor(.appFacebookColor)
            .cornerRadius(7)
            .build()
        return button
    }()
    
    private(set) var signupBtn: UIButton = {
        let button = UIButton.Builder()
            .title("新規登録")
            .component(.title_White)
            .backgroundColor(.appFacebookColor)
            .cornerRadius(7)
            .build()
        return button
    }()
}

extension TopUIImpl {
    func setup() {
        guard let vc = viewController else { return }
        vc.view.backgroundColor = .appMainColor
        vc.clearNavBar()
        [iconWrapView, loginBtn, signupBtn].forEach { vc.view.addSubview($0) }
        iconWrapView.addSubview(icon)
        
        iconWrapView.anchor()
            .centerXToSuperview()
            .top(to: vc.view.safeAreaLayoutGuide.topAnchor)
            .width(to: vc.view.widthAnchor)
            .height(to: vc.view.heightAnchor, multiplier: 0.35)
            .activate()
        
        icon.anchor()
            .centerXToSuperview()
            .centerYToSuperview()
            .width(constant: 250)
            .height(constant: 250)
            .activate()
        
        loginBtn.anchor()
            .centerXToSuperview()
            .top(to: iconWrapView.bottomAnchor, constant: 20)
            .width(to: vc.view.widthAnchor, multiplier: 0.7)
            .height(constant: 50)
            .activate()
        
        signupBtn.anchor()
            .centerXToSuperview()
            .top(to: loginBtn.bottomAnchor, constant: 35)
            .width(to: vc.view.widthAnchor, multiplier: 0.7)
            .height(constant: 50)
            .activate()
    }
}
