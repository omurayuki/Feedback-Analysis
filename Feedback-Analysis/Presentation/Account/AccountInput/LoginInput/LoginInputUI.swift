import UIKit

protocol LoginInputUI: UI {
    var cancelBtn: UIBarButtonItem { get }
    var navItem: UINavigationItem { get }
    var mailTitle: UILabel { get }
    var mailField: UITextField { get }
    var passTitle: UILabel { get }
    var passField: UITextField { get }
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
    
    var mailTitle: UILabel = {
        let label = UILabel()
        label.apply(.cap, title: "メールアドレス")
        label.textAlignment = .left
        return label
    }()
    
    var mailField: UITextField = {
        let field = UITextField()
        field.apply(.h4, hint: "メールアドレスを入力")
        return field
    }()
    
    var passTitle: UILabel = {
        let label = UILabel()
        label.apply(.cap, title: "パスワード")
        label.textAlignment = .left
        return label
    }()
    
    var passField: UITextField = {
        let field = UITextField()
        field.apply(.h4, hint: "パスワードを入力")
        return field
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
        [navBar, mailTitle, mailField, passTitle, passField, loginBtn, passRemindBtn].forEach { vc.view.addSubview($0) }
        
        navBar.anchor()
            .centerXToSuperview()
            .top(to: vc.view.safeAreaLayoutGuide.topAnchor)
            .width(to: vc.view.widthAnchor)
            .activate()
        
        mailTitle.anchor()
            .centerXToSuperview()
            .top(to: navBar.bottomAnchor, constant: 35)
            .width(to: vc.view.widthAnchor, multiplier: 0.7)
            .activate()
        
        mailField.anchor()
            .centerXToSuperview()
            .top(to: mailTitle.bottomAnchor, constant: 10)
            .width(to: vc.view.widthAnchor, multiplier: 0.7)
            .activate()
        
        passTitle.anchor()
            .centerXToSuperview()
            .top(to: mailField.bottomAnchor, constant: 20)
            .width(to: vc.view.widthAnchor, multiplier: 0.7)
            .activate()
        
        passField.anchor()
            .centerXToSuperview()
            .top(to: passTitle.bottomAnchor, constant: 10)
            .width(to: vc.view.widthAnchor, multiplier: 0.7)
            .activate()

        loginBtn.anchor()
            .centerXToSuperview()
            .top(to: passField.bottomAnchor, constant: 40)
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
