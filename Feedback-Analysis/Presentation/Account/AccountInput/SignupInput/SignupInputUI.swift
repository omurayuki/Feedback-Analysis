import UIKit

protocol SignupInputUI: UI {
    var cancelBtn: UIBarButtonItem { get }
    var navItem: UINavigationItem { get }
    var navBar: UINavigationBar { get }
    var mailInput: InputView { get }
    var passInput: InputView { get }
    var signupBtn: UIButton { get }
    
    func setup()
}

final class SignupInputUIImpl: SignupInputUI {
    
    var viewController: UIViewController?
    
    var cancelBtn: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "戻る", style: .plain, target: nil, action: nil)
        return button
    }()
    
    var navItem: UINavigationItem = {
        let nav = UINavigationItem()
        nav.title = "新規登録"
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
    
    var signupBtn: UIButton = {
        let button = UIButton.Builder()
            .title("新規登録")
            .component(.title_White)
            .backgroundColor(.appLightishGreen)
            .cornerRadius(7)
            .build()
        return button
    }()
}

extension SignupInputUIImpl {
    func setup() {
        guard let vc = viewController else { return }
        vc.view.backgroundColor = .white
        navItem.leftBarButtonItem = cancelBtn
        navBar.pushItem(navItem, animated: true)
        [navBar, mailInput, passInput, signupBtn].forEach { vc.view.addSubview($0) }
        
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
        
        signupBtn.anchor()
            .centerXToSuperview()
            .top(to: passInput.bottomAnchor, constant: vc.view.frame.height / 6)
            .width(to: vc.view.widthAnchor, multiplier: 0.5)
            .height(to: vc.view.heightAnchor, multiplier: 0.05)
            .activate()
    }
}
