import UIKit

protocol RemindUI: UI {
    var mailTitle: UILabel { get }
    var mailField: UITextField { get }
    var submitBtn: UIButton { get }
    
    func setup()
}

final class RemindUIImpl: RemindUI {
    
    var viewController: UIViewController?
    
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
    
    var submitBtn: UIButton = {
        let button = UIButton.Builder()
            .title("送信")
            .component(.title_White)
            .backgroundColor(.appFacebookColor)
            .cornerRadius(7)
            .build()
        return button
    }()
}

extension RemindUIImpl {
    func setup() {
        guard let vc = viewController else { return }
        vc.view.backgroundColor = .white
        vc.navigationItem.title = "リマインド"
        [mailTitle, mailField, submitBtn].forEach { vc.view.addSubview($0) }
        
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
        
        submitBtn.anchor()
            .centerXToSuperview()
            .top(to: mailField.bottomAnchor, constant: 35)
            .width(to: vc.view.widthAnchor, multiplier: 0.7)
            .height(constant: 50)
            .activate()
    }
}
