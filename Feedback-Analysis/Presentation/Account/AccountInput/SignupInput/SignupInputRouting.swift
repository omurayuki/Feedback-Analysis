import UIKit
import RxSwift

protocol SignupInputRouting: Routing {
    func moveMainPage()
    func cancel()
}

final class SignupInputRoutingImpl: SignupInputRouting {
    
    var viewController: UIViewController?
    
    func moveMainPage() {
        print("main")
    }
    
    func cancel() {
        viewController?.dismiss(animated: true)
    }
}
