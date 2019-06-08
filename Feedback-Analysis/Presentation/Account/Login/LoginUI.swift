import UIKit

protocol LoginUI: UI {
    var faceBookBtn: UIButton { get }
    var twitterBtn: UIButton { get }
    var mailBtn: UIButton { get }
    
    func setup()
}

final class LoginUIImpl: LoginUI {
    
    var viewController: UIViewController?
    
    var faceBookBtn: UIButton = {
        let button = UIButton.Builder()
            .title("FaceBookでログイン")
            .component(.title_White)
            .backgroundColor(.appFacebookColor)
            .cornerRadius(7)
            .build()
        return button
    }()
    
    var twitterBtn: UIButton = {
        let button = UIButton.Builder()
            .title("Twitterでログイン")
            .component(.title_White)
            .backgroundColor(.appTwitterColor)
            .cornerRadius(7)
            .build()
        return button
    }()
    
    var mailBtn: UIButton = {
        let button = UIButton.Builder()
            .title("メールアドレスでログイン")
            .component(.title_White)
            .backgroundColor(.appLightishGreen)
            .cornerRadius(7)
            .build()
        return button
    }()
}

extension LoginUIImpl {
    func setup() {
        guard let vc = viewController else { return }
        vc.view.backgroundColor = .white
        [faceBookBtn, twitterBtn, mailBtn].forEach { vc.view.addSubview($0) }
        
        faceBookBtn.anchor()
            .centerXToSuperview()
            .top(to: vc.view.topAnchor, constant: 35)
            .width(to: vc.view.widthAnchor, multiplier: 0.7)
            .height(to: vc.view.heightAnchor, multiplier: 0.12)
            .activate()
        
        twitterBtn.anchor()
            .centerXToSuperview()
            .top(to: faceBookBtn.bottomAnchor, constant: 20)
            .width(to: vc.view.widthAnchor, multiplier: 0.7)
            .height(to: vc.view.heightAnchor, multiplier: 0.12)
            .activate()
        
        mailBtn.anchor()
            .centerXToSuperview()
            .top(to: twitterBtn.bottomAnchor, constant: 20)
            .width(to: vc.view.widthAnchor, multiplier: 0.7)
            .height(to: vc.view.heightAnchor, multiplier: 0.12)
            .activate()
    }
}
