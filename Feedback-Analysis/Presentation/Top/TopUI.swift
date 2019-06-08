import UIKit

protocol TopUI: UI {
    var iconWrapView: UIView { get }
    var icon: UIImageView { get }
    var loginBtn: UIButton { get }
    var signupBtn: UIButton { get }
    var switchingView: SwitchingView { get }
    
    func setup()
}

final class TopUIImpl: TopUI {
    
    var viewController: UIViewController?
    
    private(set) var iconWrapView: UIView = {
        let view = UIView()
        return view
    }()
    
    private(set) var icon: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .gray
        image.layer.cornerRadius = 50
        return image
    }()
    
    private(set) var loginBtn: UIButton = {
        let button = UIButton.Builder()
            .title("ログイン")
            .component(.h4)
            .backgroundColor(.white)
            .build()
        return button
    }()
    
    private(set) var signupBtn: UIButton = {
        let button = UIButton.Builder()
            .title("新規登録")
            .component(.h4)
            .backgroundColor(.white)
            .build()
        return button
    }()
    
    var switchingView: SwitchingView = {
        let view = SwitchingView()
        return view
    }()
}

extension TopUIImpl {
    func setup() {
        guard let vc = viewController else { return }
        vc.view.backgroundColor = .white
        vc.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        vc.navigationController?.navigationBar.shadowImage = UIImage()
        let stack = setupStack()
        [iconWrapView, stack, switchingView].forEach { vc.view.addSubview($0) }
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
            .width(constant: 100)
            .height(constant: 100)
            .activate()
        
        loginBtn.anchor()
            .width(constant: vc.view.frame.width / 2)
            .activate()
        
        signupBtn.anchor()
            .width(constant: vc.view.frame.width / 2)
            .activate()
        
        stack.anchor()
            .top(to: iconWrapView.bottomAnchor)
            .width(to: vc.view.widthAnchor)
            .activate()
        
        switchingView.anchor()
            .top(to: stack.bottomAnchor)
            .bottom(to: vc.view.bottomAnchor)
            .width(to: vc.view.widthAnchor)
            .activate()
    }
    
    private func setupStack() -> UIStackView {
        let stack = UIStackView(arrangedSubviews: [
            loginBtn,
            signupBtn
        ])
        return stack
    }
}
