import Foundation
import UIKit
import RxSwift

protocol PublicGoalRouting: Routing {
    func showDetail(with timeline: Timeline, height: CGFloat)
    func showOnotherPeoplePage(with token: String)
}

final class PublicGoalRoutingImpl: PublicGoalRouting {
    
    var viewController: UIViewController?
    
    func showDetail(with timeline: Timeline, height: CGFloat) {
        let repository = DetailRepositoryImpl.shared
        let useCase = DetailUseCaseImpl(repository: repository)
        let presenter = DetailPresenterImpl(useCase: useCase)
        let vc = DetailViewController()
        let ui = DetailUIImpl()
        let routing = DetailRoutingImpl()
        ui.viewController = vc
        ui.detail.dataSource = vc.detailDataSource
        ui.commentTable.dataSource = vc.commentDataSource
        ui.commentTable.delegate = presenter
        ui.commentField.delegate = presenter
        routing.viewController = vc
        vc.inject(ui: ui, presenter: presenter, routing: routing, disposeBag: DisposeBag())
        vc.recieve(data: timeline, height: height)
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showOnotherPeoplePage(with token: String) {
        let createVC = CreateControllers(token: token)
        let controllers = [createVC.createGoalController(),
                           createVC.createCompleteController(),
                           createVC.createAllController()]
        controllers.enumerated().forEach { index, controller in controller.view.tag = index }
        
        let repository = OnotherPeopleRepositoryImpl.shared
        let useCase = OnotherPeopleUseCaseImpl(repository: repository)
        let presenter = OnotherPeoplePresenterImpl(useCase: useCase)
        let vc = OnotherPeopleViewController()
        let ui = OnotherPeopleUIImpl()
        let routing = OnotherPeopleRoutingImpl()
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
