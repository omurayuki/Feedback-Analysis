import Foundation
import RxSwift
import UIKit

protocol TopRouting: Routing {
    func showLogin(disposeBag: DisposeBag, view: UIView)
    func showSignup(disposeBag: DisposeBag, view: UIView)
}

final class TopRoutingImpl: TopRouting {
    var viewController: UIViewController?
    
    func showLogin(disposeBag: DisposeBag, view: UIView) {
    }
    
    func showSignup(disposeBag: DisposeBag, view: UIView) {
    }
}
