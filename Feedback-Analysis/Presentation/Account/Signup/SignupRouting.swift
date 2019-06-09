import Foundation
import UIKit
import RxSwift

protocol SignupRouting: Routing {
    func signupWithFacebook()
    func signupWithTwitter()
    func signupWithEmail()
}

final class SignupRoutingImpl: SignupRouting {
    
    var viewController: UIViewController?
    
    func signupWithFacebook() {
        print("facebook")
    }
    
    func signupWithTwitter() {
        print("twitter")
    }
    
    func signupWithEmail() {
        let vc = SignupInputViewController()
        let ui = SignupInputUIImpl()
        let routing = SignupInputRoutingImpl()
        ui.viewController = vc
        routing.viewController = vc
        vc.inject(ui: ui, disposeBag: DisposeBag(), routing: routing)
        viewController?.present(vc, animated: true)
    }
}
