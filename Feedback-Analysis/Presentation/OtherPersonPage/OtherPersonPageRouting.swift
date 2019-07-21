import Foundation
import UIKit
import RxSwift

protocol OtherPersonPageRouting: Routing {
    func showFollowListPage()
}

final class OtherPersonPageRoutingImpl: OtherPersonPageRouting {
    
    var viewController: UIViewController?
    
    func showFollowListPage() {
        let vc1 = createFollowListViewController()
        let vc2 = createFollowerListViewController()
        let controllers = [vc1, vc2]
        controllers.enumerated().forEach { index, controller in controller.view.tag = index }
        let repository = FollowRepositoryImpl.shared
        let useCase = FollowUseCaseImpl(repository: repository)
        let presenter = FollowListManagingPresenterImpl(useCase: useCase)
        let vc = FollowListManagingViewController()
        
        let ui = FollowListManagingUIImpl()
        let routing = FollowListManagingRoutingImpl()
        ui.viewController = vc
        routing.viewController = vc
        ui.followSegment.delegate = presenter
        ui.followPages.dataSource = vc
        ui.followPages.delegate = presenter
        vc.inject(ui: ui,
                  presenter: presenter,
                  routing: routing,
                  viewControllers: controllers,
                  disposeBag: DisposeBag())
        
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}

extension OtherPersonPageRoutingImpl {
    
    func createFollowListViewController() -> FollowListViewController {
        let repository = FollowRepositoryImpl.shared
        let useCase = FollowUseCaseImpl(repository: repository)
        let presenter = FollowListPresenterImpl(useCase: useCase)
        let vc = FollowListViewController(followQueryRef: .allRef(authorToken: ""))
        
        let ui = FollowListUIImpl()
        let routing = FollowListRoutingImpl()
        ui.viewController = vc
        ui.followList.dataSource = vc.dataSource
        ui.followList.delegate = presenter
        routing.viewController = vc
        vc.inject(ui: ui, presenter: presenter, routing: routing, disposeBag: DisposeBag())
        return vc
    }
    
    func createFollowerListViewController() -> FollowListViewController {
        let repository = FollowRepositoryImpl.shared
        let useCase = FollowUseCaseImpl(repository: repository)
        let presenter = FollowListPresenterImpl(useCase: useCase)
        let vc = FollowListViewController(followQueryRef: .allRef(authorToken: ""))
        
        let ui = FollowListUIImpl()
        let routing = FollowListRoutingImpl()
        ui.viewController = vc
        ui.followList.dataSource = vc.dataSource
        ui.followList.delegate = presenter
        routing.viewController = vc
        vc.inject(ui: ui, presenter: presenter, routing: routing, disposeBag: DisposeBag())
        return vc
    }
}
