import Foundation
import UIKit
import RxSwift

protocol FollowListRouting: Routing {
    func showOtherPersonPage(with: String)
}

final class FollowListRoutingImpl: FollowListRouting {
    
    var viewController: UIViewController?
    
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
        ui.timelinePages.dataSource = vc
        ui.timelinePages.delegate = presenter
        routing.viewController = vc
        vc.inject(ui: ui,
                  presenter: presenter,
                  routing: routing,
                  viewControllers: controllers,
                  disposeBag: DisposeBag())
        vc.recieve(with: token)
        
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
