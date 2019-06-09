import UIKit
import RxSwift

protocol SignupInputRouting: Routing {
    func transitionMainPage()
    func cancel()
}

final class SignupInputRoutingImpl: SignupInputRouting {
    
    var viewController: UIViewController?
    
    func transitionMainPage() {
        print("main")
    }
    
    func cancel() {
        viewController?.dismiss(animated: true)
    }
}
