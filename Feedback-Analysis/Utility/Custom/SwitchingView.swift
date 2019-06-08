import Foundation
import UIKit
import RxSwift

enum LoginOrSignup: Int {
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
            var ui: LoginUI = LoginUIImpl()
            ui.viewController = loginVC
            
            loginVC?.inject(dispose: disposeBag, ui: ui)
            addSubview(loginVC?.view ?? UIView())
            loginVC?.view.fillSuperview()
        case .signup:
            loginVC?.view.removeFromSuperview()
            signupVC = SignupViewControler()
            var ui: SignupUI = SignupUIImpl()
            ui.viewController = signupVC
            
            signupVC?.inject(dispose: disposeBag, ui: ui)
            addSubview(signupVC?.view ?? UIView())
            signupVC?.view.fillSuperview()
        }
    }
}
