import Foundation
import UIKit
import RxSwift

protocol PublicTimelineContentRouting: Routing {
    func showDetail(with timeline: Timeline, height: CGFloat)
    func showOtherPersonPage(with token: String)
}

final class PublicTimelineContentRoutingImpl: PublicTimelineContentRouting {
    
    var viewController: UIViewController?
    
    func showDetail(with timeline: Timeline, height: CGFloat) {
        let repository = DetailRepositoryImpl.shared
        let useCase = DetailUseCaseImpl(repository: repository)
        let presenter = DetailPresenterImpl(useCase: useCase)
        let vc = DetailViewController()
        let ui = DetailUIImpl()
        let routing = DetailRoutingImpl()
        ui.viewController = vc
        ui.commentTable.dataSource = vc.commentDataSource
        ui.commentTable.delegate = presenter
        ui.commentField.delegate = presenter
        routing.viewController = vc
        vc.inject(ui: ui, presenter: presenter, routing: routing, disposeBag: DisposeBag())
        vc.recieve(data: timeline, height: height)
        vc.navigationItem.rightBarButtonItem = nil
        viewController?.navigationController?.pushViewController(vc, animated: true)
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
