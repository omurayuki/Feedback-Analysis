import Foundation
import UIKit
import RxSwift

protocol DetailRouting: Routing {
    func moveGoalPostEditPage(with timeline: Timeline)
    func popToViewController()
    func showReplyPage(with timeline: Comment, height: CGFloat)
}

final class DetailRoutingImpl: DetailRouting {
    
    var viewController: UIViewController?
    
    var halfModalTransitioningDelegate: HalfModalTransitioningDelegate?
    
    func moveGoalPostEditPage(with timeline: Timeline) {
        let repository = GoalRepositoryImpl.shared
        let useCase = GoalPostUseCaseImpl(repository: repository)
        let presenter = GoalPostEditPresenterImpl(useCase: useCase)
        let vc = GoalPostEditViewController()
        
        let ui = GoalPostEditUIImpl()
        let routing = GoalPostEditRoutingImpl()
        ui.viewController = vc
        ui.goalPostSegmented.delegate = presenter
        ui.slides = [GenreView(), NewThingsView(), ExpectedResultView()]
        routing.viewController = vc
        
        vc.inject(ui: ui,
                  presenter: presenter,
                  routing: routing,
                  disposeBag: DisposeBag())
        vc.recieve(data: timeline)
        
        viewController?.present(vc, animated: true)
    }
    
    func popToViewController() {
        viewController?.navigationController?.popViewController(animated: true)
    }
    
    func showReplyPage(with comment: Comment, height: CGFloat) {
        guard let `self` = viewController else { return }
        let repository = DetailRepositoryImpl.shared
        let useCase = DetailUseCaseImpl(repository: repository)
        let presenter = ReplyPresenterImpl(useCase: useCase)
        let vc = ReplyViewController()
        let ui = ReplyUIImpl()
        let routing = ReplyRoutingImpl()
        ui.viewController = vc
        ui.comment.dataSource = vc.commentDataSource
        ui.replyTable.dataSource = vc.replyDataSource
        ui.replyField.delegate = presenter
        routing.viewController = vc
        vc.inject(ui: ui, presenter: presenter, routing: routing, disposeBag: DisposeBag())
        vc.recieve(data: comment, height: height)
        let navVC = AppNavController(rootViewController: vc)
        
        halfModalTransitioningDelegate = HalfModalTransitioningDelegate(viewController: `self`,
                                                                        presentingViewController: navVC)
        navVC.modalPresentationStyle = .custom
        navVC.transitioningDelegate = halfModalTransitioningDelegate
        `self`.present(navVC, animated: true)
    }
}
