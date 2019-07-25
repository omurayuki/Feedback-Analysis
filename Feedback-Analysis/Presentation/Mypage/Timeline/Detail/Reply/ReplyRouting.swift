import Foundation
import UIKit
import RxSwift

protocol ReplyRouting: Routing {
    func dismiss()
    func showOtherPersonPage(with token: String)
}

final class ReplyRoutingImpl: ReplyRouting {
    
    var viewController: UIViewController?
    
    func dismiss() {
        viewController?.dismiss(animated: true)
    }
    
    func showOtherPersonPage(with token: String) {
        let createVC = CreateControllers(token: token)
        let controllers = [createVC.createGoalController(),
                           createVC.createCompleteController(),
                           createVC.createAllController()]
        controllers.enumerated().forEach { index, controller in controller.view.tag = index }
        
        let repository = OtherPersonPageRepositoryImpl.shared
        let useCase = OtherPersonPageUseCaseImpl(repository: repository)
        let presenter = OtherPersonPagePresenterImpl(useCase: useCase)
        let vc = OtherPersonPageViewController()
        let ui = OtherPersonPageUIImpl()
        let routing = OtherPersonPageRoutingImpl()
        ui.viewController = vc
        ui.timelineSegmented.delegate = presenter
        ui.timelinePages.delegate = presenter
        routing.viewController = vc
        vc.inject(ui: ui,
                  presenter: presenter,
                  routing: routing,
                  viewControllers: controllers,
                  disposeBag: DisposeBag())
        
        vc.recieve(with: token)
        ui.timelinePages.dataSource = vc.dataSource
        
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
