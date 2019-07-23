import Foundation
import UIKit
import RxSwift

protocol Routing {
    var viewController: UIViewController? { get set }
    
    func createFollowListViewController(queryRef: FirebaseQueryRef) -> FollowListViewController
    func createFollowerListViewController(queryRef: FirebaseQueryRef) -> FollowListViewController
}

extension Routing {
    
    func createFollowListViewController(queryRef: FirebaseQueryRef) -> FollowListViewController {
        let repository = FollowRepositoryImpl.shared
        let useCase = FollowUseCaseImpl(repository: repository)
        let presenter = FollowListPresenterImpl(useCase: useCase)
        let vc = FollowListViewController(followQueryRef: queryRef)
        
        let ui = FollowListUIImpl()
        let routing = FollowListRoutingImpl()
        ui.viewController = vc
        ui.followList.dataSource = vc.dataSource
        ui.followList.delegate = presenter
        routing.viewController = vc
        vc.inject(ui: ui, presenter: presenter, routing: routing, disposeBag: DisposeBag())
        return vc
    }
    
    func createFollowerListViewController(queryRef: FirebaseQueryRef) -> FollowListViewController {
        let repository = FollowRepositoryImpl.shared
        let useCase = FollowUseCaseImpl(repository: repository)
        let presenter = FollowListPresenterImpl(useCase: useCase)
        let vc = FollowListViewController(followQueryRef: queryRef)
        
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
