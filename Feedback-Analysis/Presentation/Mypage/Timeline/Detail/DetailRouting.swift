import Foundation
import UIKit
import RxSwift

protocol DetailRouting: Routing {
    func moveGoalPostEditPage()
}

final class DetailRoutingImpl: DetailRouting {
    
    var viewController: UIViewController?
    
    func moveGoalPostEditPage() {
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
        
        viewController?.present(vc, animated: true)
    }
}
