import Foundation
import UIKit
import RxSwift

enum LoginOrSignup {
    case login
    case signup
}

class SwitchingView: UIView {
    var loginVC: LoginViewControler?
    var signupVC: SignupViewControler?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}

extension SwitchingView {
    func showLoginOrSignup(disposeBag: DisposeBag, tag: LoginOrSignup) {
        switch tag {
        case .login:
            signupVC?.view.removeFromSuperview()
            loginVC = LoginViewControler()
            let ui = LoginUIImpl()
            let routing = LoginRoutingImpl()
            ui.viewController = loginVC
            routing.viewController = loginVC
            
            loginVC?.inject(ui: ui, disposeBag: disposeBag, routing: routing)
            addSubview(loginVC?.view ?? UIView())
            loginVC?.view.fillSuperview()
        case .signup:
            loginVC?.view.removeFromSuperview()
            signupVC = SignupViewControler()
            let ui = SignupUIImpl()
            let routing = SignupRoutingImpl()
            ui.viewController = signupVC
            routing.viewController = signupVC
            
            signupVC?.inject(ui: ui, disposeBag: disposeBag, routing: routing)
            addSubview(signupVC?.view ?? UIView())
            signupVC?.view.fillSuperview()
        }
    }
}
