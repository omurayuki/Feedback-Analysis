import UIKit

protocol LoginInputUI: UI {
    var cancelBtn: UIBarButtonItem { get }
    var navItem: UINavigationItem { get }
    var mailInput: InputView { get }
    var passInput: InputView { get }
    var loginBtn: UIButton { get }
    var passRemindBtn: UIButton { get }
    var navBar: UINavigationBar { get }
    
    func setup()
}

final class LoginInputUIImpl: LoginInputUI {
    
    var viewController: UIViewController?
    
    var cancelBtn: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "戻る", style: .plain, target: nil, action: nil)
        return button
    }()
    
    var navItem: UINavigationItem = {
        let nav = UINavigationItem()
        nav.title = "ログイン"
        return nav
    }()
    
    var navBar: UINavigationBar = {
        let bar = UINavigationBar()
        bar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        bar.shadowImage = UIImage()
        bar.barTintColor = .white
        return bar
    }()
    
    var mailInput: InputView = {
        let input = InputView.Builder()
            .title("メールアドレス")
            .hint("メールアドレスを入力")
            .alignment(.left)
            .keyboardType(.emailAddress)
            .build()
        return input
    }()
    
    var passInput: InputView = {
        let input = InputView.Builder()
            .title("パスワード")
            .hint("パスワードを入力")
            .alignment(.left)
            .keyboardType(.default)
            .build()
        return input
    }()
    
    var loginBtn: UIButton = {
        let button = UIButton.Builder()
            .title("ログイン")
            .component(.title_White)
            .backgroundColor(.appLightishGreen)
            .cornerRadius(7)
            .build()
        return button
    }()
    
    var passRemindBtn: UIButton = {
        let button = UIButton.Builder()
            .title("パスワードを忘れた方へ")
            .component(.cap_LightGray)
            .backgroundColor(.appLightishGreen)
            .cornerRadius(7)
            .build()
        return button
    }()
}

extension LoginInputUIImpl {
    func setup() {
        guard let vc = viewController else { return }
        vc.view.backgroundColor = .white
        navItem.leftBarButtonItem = cancelBtn
        navBar.pushItem(navItem, animated: true)
        [navBar, mailInput, passInput, loginBtn, passRemindBtn].forEach { vc.view.addSubview($0) }
        
        navBar.anchor()
            .centerXToSuperview()
            .top(to: vc.view.safeAreaLayoutGuide.topAnchor)
            .width(to: vc.view.widthAnchor)
            .activate()
        
        mailInput.anchor()
            .top(to: navBar.bottomAnchor)
            .width(to: vc.view.widthAnchor)
            .activate()
        
        passInput.anchor()
            .top(to: mailInput.bottomAnchor, constant: vc.view.frame.height / 10)
            .width(to: vc.view.widthAnchor)
            .activate()

        loginBtn.anchor()
            .centerXToSuperview()
            .top(to: passInput.bottomAnchor, constant: vc.view.frame.height / 6)
            .width(to: vc.view.widthAnchor, multiplier: 0.5)
            .height(to: vc.view.heightAnchor, multiplier: 0.05)
            .activate()

        passRemindBtn.anchor()
            .centerXToSuperview()
            .top(to: loginBtn.bottomAnchor, constant: 20)
            .width(to: vc.view.widthAnchor, multiplier: 0.5)
            .height(to: vc.view.heightAnchor, multiplier: 0.05)
            .activate()
    }
}
