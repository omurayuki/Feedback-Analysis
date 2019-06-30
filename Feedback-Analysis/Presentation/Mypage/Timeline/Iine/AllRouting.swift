import Foundation
import UIKit
import RxSwift

protocol AllRouting: Routing {
    func showDetail(with timeline: Timeline, height: CGFloat)
}

final class AllRoutingImpl: AllRouting {
    
    var viewController: UIViewController?
    
    func showDetail(with timeline: Timeline, height: CGFloat) {
        let presenter = DetailPresenterImpl()
        let vc = DetailViewController()
        let ui = DetailUIImpl()
        let routing = DetailRoutingImpl()
        ui.viewController = vc
        ui.detail.dataSource = vc.detailDataSource
        routing.viewController = vc
        vc.inject(ui: ui, presenter: presenter, routing: routing, disposeBag: DisposeBag())
        vc.recieve(data: timeline, height: height)
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
