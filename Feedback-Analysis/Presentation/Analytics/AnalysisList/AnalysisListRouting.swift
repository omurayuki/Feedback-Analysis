import Foundation
import UIKit

protocol AnalysisListRouting: Routing {
    func showAnalysisPage()
}

final class AnalysisListRoutingImpl: AnalysisListRouting {
    
    var viewController: UIViewController?

    func showAnalysisPage() {
        let repository = TimelineRepositoryImpl.shared
        let useCase = TimelineUseCaseImpl(repository: repository)
        let presenter = AnalysisPresenterImpl(useCase: useCase)
        let vc = AnalysisViewController()
        
        let ui = AnalysisUIImpl()
        let routing = AnalysisRoutingImpl()
        ui.viewController = vc
        ui.segment.delegate = presenter
        ui.slides = [AnalysisView(), AnalysisView(), AnalysisView(), StrengthView()]
        routing.viewController = vc
        
        vc.inject(ui: ui,
                  presenter: presenter,
                  routing: routing)
        
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
