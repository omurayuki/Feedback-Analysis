import Foundation
import UIKit

protocol LoginInputRouting: Routing {
    func transitionMainPage()
    func transitionRemindPage()
    func cancel()
}

final class LoginInputRoutingImpl: LoginInputRouting {
    
    var viewController: UIViewController?
    
    func transitionMainPage() {
        print("main")
    }
    
    func transitionRemindPage() {
        print("remind")
    }
    
    func cancel() {
        viewController?.dismiss(animated: true)
    }
}
