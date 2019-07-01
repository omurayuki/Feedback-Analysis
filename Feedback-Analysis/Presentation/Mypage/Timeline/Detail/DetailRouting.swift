import Foundation
import UIKit
import RxSwift

protocol DetailRouting: Routing {
    func moveGoalPostEditPage(with timeline: Timeline)
}

final class DetailRoutingImpl: DetailRouting {
    
    var viewController: UIViewController?
    
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
}
