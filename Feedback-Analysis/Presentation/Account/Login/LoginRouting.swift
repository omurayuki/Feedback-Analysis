import Foundation
import UIKit
import RxSwift

protocol LoginRouting: Routing {
    func loginWithFacebook()
    func loginWithTwitter()
    func loginWithEmail()
}

final class LoginRoutingImpl: LoginRouting {
    var viewController: UIViewController?
    
    func loginWithFacebook() {
        print("facebook")
    }
    
    func loginWithTwitter() {
        print("twitter")
    }
    
    func loginWithEmail() {
        let vc = LoginInputViewController()
        let ui = LoginInputUIImpl()
        let routing = LoginInputRoutingImpl()
        ui.viewController = vc
        routing.viewController = vc
        vc.inject(ui: ui, disposeBag: DisposeBag(), routing: routing)
        viewController?.present(vc, animated: true)
    }
}
