import UIKit

protocol LoginInputUI: UI {
    var mailTitle: UILabel { get }
    var mailField: PaddingTextField { get }
    var passTitle: UILabel { get }
    var passField: PaddingTextField { get }
    var loginBtn: UIButton { get }
    var passRemindBtn: UIButton { get }
    
    func setup()
}

final class LoginInputUIImpl: LoginInputUI {
    
    weak var viewController: UIViewController?
    
    private(set) var mailTitle: UILabel = {
        let label = UILabel()
        label.apply(.appMain10, title: "メールアドレス")
        label.textAlignment = .left
        return label
    }()
    
    private(set) var mailField: PaddingTextField = {
        let field = PaddingTextField()
        field.apply(.h5_appSub)
        field.textColor = .appSubColor
        field.backgroundColor = UIColor(white: 1, alpha: 0.5)
        field.layer.cornerRadius = 5
        return field
    }()
    
    private(set) var passTitle: UILabel = {
        let label = UILabel()
        label.apply(.appMain10, title: "パスワード")
        label.textAlignment = .left
        return label
    }()
    
    private(set) var passField: PaddingTextField = {
        let field = PaddingTextField()
        field.apply(.h5_appSub)
        field.textColor = .appSubColor
        field.backgroundColor = UIColor(white: 1, alpha: 0.5)
        field.layer.cornerRadius = 5
        field.isSecureTextEntry = true
        return field
    }()
    
    private(set) var loginBtn: UIButton = {
        let button = UIButton.Builder()
            .title("ログイン")
            .component(.title_White)
            .backgroundColor(.appSubColor)
            .cornerRadius(7)
            .build()
        return button
    }()
    
    private(set) var passRemindBtn: UIButton = {
        let button = UIButton.Builder()
            .title("パスワードを忘れた方")
            .component(.title_White)
            .backgroundColor(.appSubColor)
            .cornerRadius(7)
            .build()
        return button
    }()
}

extension LoginInputUIImpl {
    func setup() {
        guard let vc = viewController else { return }
        vc.view.backgroundColor = .appMainColor
        
        [mailTitle, mailField, passTitle, passField, loginBtn, passRemindBtn].forEach { vc.view.addSubview($0) }
        
        mailTitle.anchor()
            .centerXToSuperview()
            .top(to: vc.view.safeAreaLayoutGuide.topAnchor, constant: 35)
            .width(to: vc.view.widthAnchor, multiplier: 0.7)
            .activate()
        
        mailField.anchor()
            .centerXToSuperview()
            .top(to: mailTitle.bottomAnchor, constant: 10)
            .width(to: vc.view.widthAnchor, multiplier: 0.7)
            .height(constant: 30)
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
            .height(constant: 30)
            .activate()

        loginBtn.anchor()
            .centerXToSuperview()
            .top(to: passField.bottomAnchor, constant: 40)
            .width(to: vc.view.widthAnchor, multiplier: 0.7)
            .height(constant: 50)
            .activate()

        passRemindBtn.anchor()
            .centerXToSuperview()
            .top(to: loginBtn.bottomAnchor, constant: 35)
            .width(to: vc.view.widthAnchor, multiplier: 0.7)
            .height(constant: 50)
            .activate()
    }
}
