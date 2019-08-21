import Foundation
import UIKit
import RxSwift

protocol AnalysisResultRouting: Routing {
    func showCompletesPage(_ completes: [Complete])
}

final class AnalysisResultRoutingImpl: AnalysisResultRouting {
    
    var viewController: UIViewController?
    
    func showCompletesPage(_ completes: [Complete]) {
        let repository = TimelineRepositoryImpl.shared
        let useCase = TimelineUseCaseImpl(repository: repository)
        let presenter = CategorizedPresenterImpl(useCase: useCase)
        let vc = CategorizedViewController()
        
        let ui = CategorizedUIImpl()
        let routing = CategorizedRoutingImpl()
        ui.viewController = vc
        ui.tableView.dataSource = vc.dataSource
        ui.tableView.delegate = presenter
        routing.viewController = vc
        vc.recieve(complete: completes)
        
        vc.inject(ui: ui,
                  presenter: presenter,
                  routing: routing,
                  disposeBag: DisposeBag())
        
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
