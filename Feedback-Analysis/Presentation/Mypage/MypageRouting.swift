import Foundation
import UIKit
import RxSwift

protocol MypageRouting: Routing {
    func moveEditPage(user: UpdatingItem)
}

final class MypageRoutingImpl: MypageRouting {
    
    var viewController: UIViewController?
    
    func moveEditPage(user: UpdatingItem) {
        let repository = MypageRepositoryImpl.shared
        let useCase = EditUseCaseImpl(repository: repository)
        let presenter = EditPresenterImpl(useCase: useCase)
        let vc = EditViewController()
        
        let ui = EditUIImpl()
        let routing = EditRoutingImpl()
        vc.delegate = viewController as? MypageViewController
        ui.viewController = vc
        routing.viewController = vc
        vc.inject(ui: ui,
                  presenter: presenter,
                  routing: routing,
                  disposeBag: DisposeBag(),
                  user: user)
        viewController?.present(vc, animated: true)
    }
}
