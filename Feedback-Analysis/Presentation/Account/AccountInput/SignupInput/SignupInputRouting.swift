import UIKit
import RxSwift

protocol SignupInputRouting: Routing {
    func moveMainPage()
    func cancel()
}

final class SignupInputRoutingImpl: SignupInputRouting {
    
    var viewController: UIViewController?
    
    func moveMainPage() {
        let vc = MainTabController()
        viewController?.present(vc, animated: true)
    }
    
    func cancel() {
        viewController?.dismiss(animated: true)
    }
}
