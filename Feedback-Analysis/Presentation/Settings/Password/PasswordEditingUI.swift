import UIKit

protocol PasswordEditingUI: UI {
    var emailTitle: UILabel { get }
    var emailField: PaddingTextField { get }
    var oldPasswordTitle: UILabel { get }
    var oldPasswordField: PaddingTextField { get }
    var newPasswordTitle: UILabel { get }
    var newPasswordField: PaddingTextField { get }
    var updateBtn: UIButton { get }
    
    func setup()
}

final class PasswordEditingUIImpl: PasswordEditingUI {
    
    weak var viewController: UIViewController?
    
    private(set) var emailTitle: UILabel = {
        let label = UILabel()
        label.apply(.appMain10, title: "メールアドレス")
        label.textAlignment = .left
        return label
    }()
    
    private(set) var emailField: PaddingTextField = {
        let field = PaddingTextField()
        field.apply(.h5_appSub)
        field.textColor = .appSubColor
        field.backgroundColor = UIColor(white: 1, alpha: 0.5)
        field.layer.cornerRadius = 5
        return field
    }()
    
    private(set) var oldPasswordTitle: UILabel = {
        let label = UILabel()
        label.apply(.appMain10, title: "古いパスワード")
        label.textAlignment = .left
        return label
    }()
    
    private(set) var oldPasswordField: PaddingTextField = {
        let field = PaddingTextField()
        field.apply(.h5_appSub)
        field.textColor = .appSubColor
        field.backgroundColor = UIColor(white: 1, alpha: 0.5)
        field.layer.cornerRadius = 5
        field.isSecureTextEntry = true
        return field
    }()
    
    private(set) var newPasswordTitle: UILabel = {
        let label = UILabel()
        label.apply(.appMain10, title: "新しいパスワード")
        label.textAlignment = .left
        return label
    }()
    
    private(set) var newPasswordField: PaddingTextField = {
        let field = PaddingTextField()
        field.apply(.h5_appSub)
        field.textColor = .appSubColor
        field.backgroundColor = UIColor(white: 1, alpha: 0.5)
        field.layer.cornerRadius = 5
        field.isSecureTextEntry = true
        return field
    }()
    
    private(set) var updateBtn: UIButton = {
        let button = UIButton.Builder()
            .title("送信")
            .component(.title_White)
            .backgroundColor(.appSubColor)
            .cornerRadius(7)
            .build()
        return button
    }()
}

extension PasswordEditingUIImpl {
    func setup() {
        guard let vc = viewController else { return }
        vc.view.backgroundColor = .appMainColor
        
        [emailTitle, emailField, oldPasswordTitle,
         oldPasswordField, newPasswordTitle, newPasswordField, updateBtn].forEach { vc.view.addSubview($0) }
        
        emailTitle.anchor()
            .centerXToSuperview()
            .top(to: vc.view.safeAreaLayoutGuide.topAnchor, constant: 35)
            .width(to: vc.view.widthAnchor, multiplier: 0.7)
            .activate()
        
        emailField.anchor()
            .centerXToSuperview()
            .top(to: emailTitle.bottomAnchor, constant: 10)
            .width(to: vc.view.widthAnchor, multiplier: 0.7)
            .height(constant: 35)
            .activate()
        
        oldPasswordTitle.anchor()
            .centerXToSuperview()
            .top(to: emailField.bottomAnchor, constant: 25)
            .width(to: vc.view.widthAnchor, multiplier: 0.7)
            .activate()
        
        oldPasswordField.anchor()
            .centerXToSuperview()
            .top(to: oldPasswordTitle.bottomAnchor, constant: 10)
            .width(to: vc.view.widthAnchor, multiplier: 0.7)
            .height(constant: 35)
            .activate()
        
        newPasswordTitle.anchor()
            .centerXToSuperview()
            .top(to: oldPasswordField.bottomAnchor, constant: 25)
            .width(to: vc.view.widthAnchor, multiplier: 0.7)
            .activate()
        
        newPasswordField.anchor()
            .centerXToSuperview()
            .top(to: newPasswordTitle.bottomAnchor, constant: 10)
            .width(to: vc.view.widthAnchor, multiplier: 0.7)
            .height(constant: 35)
            .activate()
        
        updateBtn.anchor()
            .centerXToSuperview()
            .top(to: newPasswordField.bottomAnchor, constant: 40)
            .width(to: vc.view.widthAnchor, multiplier: 0.7)
            .height(constant: 50)
            .activate()
    }
}
