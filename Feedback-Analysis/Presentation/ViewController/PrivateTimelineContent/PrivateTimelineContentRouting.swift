import Foundation
import UIKit
import RxSwift

protocol PrivateTimelineContentRouting: Routing {
    func showDetail(with timeline: Timeline, height: CGFloat, completion: (() -> Void)?)
}

final class PrivateTimelineContentRoutingImpl: PrivateTimelineContentRouting {
    
    var viewController: UIViewController?
    
    func showDetail(with timeline: Timeline, height: CGFloat, completion: (() -> Void)? = nil) {
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
        viewController?.navigationController?.pushViewController(vc, animated: true)
        completion?()
    }
}
