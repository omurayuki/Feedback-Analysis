import UIKit

protocol EmailEditingUI: UI {
    var mailTitle: UILabel { get }
    var emailField: PaddingTextField { get }
    var updateBtn: UIButton { get }
    
    func setup(with email: String)
}

final class EmailEditingUIImpl: EmailEditingUI {
    
    weak var viewController: UIViewController?
    
    private(set) var mailTitle: UILabel = {
        let label = UILabel()
        label.apply(.appMain10, title: "メールアドレス")
        label.textAlignment = .left
        return label
    }()
    
    var emailField: PaddingTextField = {
        let field = PaddingTextField()
        field.apply(.h4)
        field.backgroundColor = UIColor(white: 1, alpha: 0.5)
        field.layer.cornerRadius = 5
        return field
    }()
    
    var updateBtn: UIButton = {
        let button = UIButton.Builder()
            .title("送信")
            .component(.title_White)
            .backgroundColor(.appSubColor)
            .cornerRadius(7)
            .build()
        return button
    }()
}

extension EmailEditingUIImpl {
    func setup(with email: String) {
        guard let vc = viewController else { return }
        vc.view.backgroundColor = .appMainColor
        
        [mailTitle, emailField, updateBtn].forEach { vc.view.addSubview($0) }
        
        mailTitle.anchor()
            .centerXToSuperview()
            .top(to: vc.view.safeAreaLayoutGuide.topAnchor, constant: 35)
            .width(to: vc.view.widthAnchor, multiplier: 0.7)
            .activate()
        
        emailField.anchor()
            .centerXToSuperview()
            .top(to: mailTitle.bottomAnchor, constant: 10)
            .width(to: vc.view.widthAnchor, multiplier: 0.7)
            .height(constant: 35)
            .activate()
        
        updateBtn.anchor()
            .centerXToSuperview()
            .top(to: emailField.bottomAnchor, constant: 40)
            .width(to: vc.view.widthAnchor, multiplier: 0.7)
            .height(constant: 50)
            .activate()
        
        emailField.text = email
    }
}
