import UIKit

protocol SignupInputUI: UI {
    var mailTitle: UILabel { get }
    var mailField: UITextField { get }
    var passTitle: UILabel { get }
    var passField: UITextField { get }
    var signupBtn: UIButton { get }
    
    func setup()
}

final class SignupInputUIImpl: SignupInputUI {
    
    weak var viewController: UIViewController?
    
    private(set) var mailTitle: UILabel = {
        let label = UILabel()
        label.apply(.cap, title: "メールアドレス")
        label.textAlignment = .left
        return label
    }()
    
    private(set) var mailField: UITextField = {
        let field = UITextField()
        field.apply(.h4, hint: "メールアドレスを入力")
        return field
    }()
    
    private(set) var passTitle: UILabel = {
        let label = UILabel()
        label.apply(.cap, title: "パスワード")
        label.textAlignment = .left
        return label
    }()
    
    private(set) var passField: UITextField = {
        let field = UITextField()
        field.apply(.h4, hint: "パスワードを入力")
        return field
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

extension SignupInputUIImpl {
    func setup() {
        guard let vc = viewController else { return }
        vc.view.backgroundColor = .white
        vc.navigationItem.title = "新規登録"
        [mailTitle, mailField, passTitle, passField, signupBtn].forEach { vc.view.addSubview($0) }
        
        mailTitle.anchor()
            .centerXToSuperview()
            .top(to: vc.view.safeAreaLayoutGuide.topAnchor, constant: 35)
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
        
        signupBtn.anchor()
            .centerXToSuperview()
            .top(to: passField.bottomAnchor, constant: 50)
            .width(to: vc.view.widthAnchor, multiplier: 0.7)
            .height(constant: 50)
            .activate()
    }
}
