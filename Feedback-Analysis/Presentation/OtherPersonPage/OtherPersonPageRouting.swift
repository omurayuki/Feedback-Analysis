import Foundation
import UIKit
import RxSwift

protocol OtherPersonPageRouting: Routing {
    func showFollowListPage()
    func showMessagePage(conversation: Conversation)
}

final class OtherPersonPageRoutingImpl: OtherPersonPageRouting {
    
    var viewController: UIViewController?
    
    func showFollowListPage() {
        let vc1 = createFollowListViewController(queryRef: .followeeRefFromOtherPerson)
        let vc2 = createFollowerListViewController(queryRef: .followerRefFromOtherPerson)
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
        ui.followPages.delegate = presenter
        vc.inject(ui: ui,
                  presenter: presenter,
                  routing: routing,
                  viewControllers: controllers,
                  disposeBag: DisposeBag())
        
        ui.followPages.dataSource = vc.dataSource
        
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showMessagePage(conversation: Conversation) {
        let repository = ConversationRepositoryImpl.shared
        let useCase = ConversationUseCaseImpl(repository: repository)
        let presenter = MessagesPresenterImpl(useCase: useCase)
        let routing = MessagesRoutingImpl()
        let sb = UIStoryboard(name: "Messages", bundle: nil)
        if let vc = sb.instantiateViewController(withIdentifier: "MessagesViewController") as? MessagesViewController {
            routing.viewController = vc
            vc.inject(presenter: presenter, routing: routing)
            vc.recieve(conversation: conversation)
            viewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
