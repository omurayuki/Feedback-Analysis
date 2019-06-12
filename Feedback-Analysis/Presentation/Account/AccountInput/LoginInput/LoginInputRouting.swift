import Foundation
import UIKit
import RxSwift

protocol LoginInputRouting: Routing {
    func moveMainPage()
    func moveRemindPage()
    func cancel()
}

final class LoginInputRoutingImpl: LoginInputRouting {
    
    var viewController: UIViewController?
    
    func moveMainPage() {
        print("main")
    }
    
    func moveRemindPage() {
        let repository = AccountRepositoryImpl.shared
        let useCase = RemindUseCaseImpl(repository: repository)
        let presenter = RemindPresenterImpl(useCase: useCase)
        
        let vc = RemindViewController()
        let ui = RemindUIImpl()
        let routing = RemindRoutingImpl()
        ui.viewController = vc
        routing.viewController = vc
        vc.inject(ui: ui,
                  presenter: presenter,
                  disposeBag: DisposeBag(),
                  routing: routing)
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func cancel() {
        viewController?.dismiss(animated: true)
    }
}
