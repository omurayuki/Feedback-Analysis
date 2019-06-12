import Foundation
import RxSwift
import UIKit

protocol TopRouting: Routing {
    func login()
    func signup()
}

final class TopRoutingImpl: TopRouting {
    
    var viewController: UIViewController?
    
    func login() {
        let repository = AccountRepositoryImpl.shared
        let useCase = LoginUseCaseImpl(repository: repository)
        let presenter = LoginInputPresenterImpl(useCase: useCase)
        
        let vc = LoginInputViewController()
        let ui = LoginInputUIImpl()
        let routing = LoginInputRoutingImpl()
        ui.viewController = vc
        routing.viewController = vc
        vc.inject(ui: ui, presenter: presenter, disposeBag: DisposeBag(), routing: routing)
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func signup() {
        let repository = AccountRepositoryImpl.shared
        let useCase = SignupUseCaseImpl(repository: repository)
        let presenter = SignupInputPresenterImpl(useCase: useCase)
        
        let vc = SignupInputViewController()
        let ui = SignupInputUIImpl()
        let routing = SignupInputRoutingImpl()
        ui.viewController = vc
        routing.viewController = vc
        vc.inject(ui: ui,
                  presenter: presenter,
                  disposeBag: DisposeBag(),
                  routing: routing)
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
