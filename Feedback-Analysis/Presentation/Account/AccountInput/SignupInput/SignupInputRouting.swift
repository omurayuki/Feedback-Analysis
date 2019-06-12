import UIKit
import RxSwift

protocol SignupInputRouting: Routing {
    func moveMainPage()
    func cancel()
}

final class SignupInputRoutingImpl: SignupInputRouting {
    
    var viewController: UIViewController?
    
    func moveMainPage() {
        let vc = MainTabController(timeline: UIViewController(),
                                   notification: UIViewController(),
                                   mailList: UIViewController(),
                                   mypage: UIViewController())
        viewController?.present(vc, animated: true)
    }
    
    func cancel() {
        viewController?.dismiss(animated: true)
    }
}
