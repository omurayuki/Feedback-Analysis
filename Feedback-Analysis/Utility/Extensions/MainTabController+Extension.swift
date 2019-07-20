import Foundation
import UIKit
import RxSwift

protocol MainTabbarProtocol where Self: MainTabController {
    func setup()
}

extension MainTabController: MainTabbarProtocol {
    
    func setup() {
        tabBar.barStyle = .default
        tabBar.clipsToBounds = true
        
        var resouces = [#imageLiteral(resourceName: "diary"), #imageLiteral(resourceName: "bell"), #imageLiteral(resourceName: "mail"), #imageLiteral(resourceName: "home")]
        var viewControllers: [UIViewController] = []
        
        [initTimelineVC(), UIViewController(), UIViewController(), initMypageVC(with: AppUserDefaults.getAuthToken())].enumerated().forEach { index, controller in
            let navi = UINavigationController(rootViewController: controller)
            navi.tabBarItem = UITabBarItem(title: nil, image: resouces[index], tag: index)
            
            viewControllers.append(navi)
        }
        
        setViewControllers(viewControllers, animated: false)
        selectedIndex = 0
    }
    
    private func initTimelineVC() -> TimelineViewController {
        let controllers = [cretePublicGoalController(),
                           cretePublicCompleteController(),
                           UIViewController()]
        controllers.enumerated().forEach { index, controller in controller.view.tag = index }
        let repository = TimelineRepositoryImpl.shared
        let useCase = TimelineUseCaseImpl(repository: repository)
        let presenter = TimelinePresenterImpl(useCase: useCase)
        let vc = TimelineViewController()
        
        let ui = TimelineUIImpl()
        let routing = TimelineRoutingImpl()
        ui.viewController = vc
        routing.viewController = vc
        ui.timelineSegmented.delegate = presenter
        ui.timelinePages.dataSource = vc
        ui.timelinePages.delegate = presenter
        vc.inject(ui: ui,
                  presenter: presenter,
                  routing: routing,
                  viewControllers: controllers,
                  disposeBag: DisposeBag())
        
        return vc
    }
    
    private func initMypageVC(with token: String) -> MypageViewController {
        let createVC = CreateControllers(token: token)
        let controllers = [createVC.createGoalController(), createVC.createCompleteController(),
                           createVC.createDraftController(), createVC.createAllController()]
        controllers.enumerated().forEach { index, controller in controller.view.tag = index }
        
        let repository = MypageRepositoryImpl.shared
        let useCase = MypageUseCaseImpl(repository: repository)
        let presenter = MypagePresenterImpl(useCase: useCase)
        let vc = MypageViewController()
        
        let ui = MypageUIImpl()
        let routing = MypageRoutingImpl()
        ui.viewController = vc
        ui.timelineSegmented.delegate = presenter
        ui.timelinePages.dataSource = vc
        ui.timelinePages.delegate = presenter
        routing.viewController = vc
        vc.inject(ui: ui,
                  presenter: presenter,
                  routing: routing,
                  viewControllers: controllers,
                  disposeBag: DisposeBag())
        
        return vc
    }
}

extension MainTabController {
    
    func cretePublicGoalController() -> UIViewController {
        let repository = TimelineRepositoryImpl.shared
        let useCase = TimelineUseCaseImpl(repository: repository)
        let presenter = PublicGoalPresenterImpl(useCase: useCase)
        let vc = PublicGoalViewController()
        
        let ui = PublicGoalUIImpl()
        let routing = PublicGoalRoutingImpl()
        ui.viewController = vc
        ui.timeline.dataSource = vc.dataSource
        ui.timeline.delegate = presenter
        routing.viewController = vc
        vc.inject(ui: ui, presenter: presenter, routing: routing, disposeBag: DisposeBag())
        return vc
    }
    
    func cretePublicCompleteController() -> UIViewController {
        let repository = TimelineRepositoryImpl.shared
        let useCase = TimelineUseCaseImpl(repository: repository)
        let presenter = PublicCompletePresenterImpl(useCase: useCase)
        let vc = PublicCompleteViewController()
        
        let ui = PublicCompleteUIImpl()
        let routing = PublicCompleteRoutingImpl()
        ui.viewController = vc
        ui.timeline.dataSource = vc.dataSource
        ui.timeline.delegate = presenter
        routing.viewController = vc
        vc.inject(ui: ui, presenter: presenter, routing: routing, disposeBag: DisposeBag())
        return vc
    }
}

class CreateControllers: NSObject {
    
    var token: String
    
    init(token: String) {
        self.token = token
    }
    
    func createGoalController() -> UIViewController {
        let repository = GoalRepositoryImpl.shared
        let useCase = GoalPostUseCaseImpl(repository: repository)
        let presenter = PrivateGoalPresenterImpl(useCase: useCase)
        let vc = PrivateGoalViewController()
        
        let ui = PrivateGoalUIImpl()
        let routing = PrivateGoalRoutingImpl()
        ui.viewController = vc
        ui.timeline.dataSource = vc.dataSource
        ui.timeline.delegate = presenter
        routing.viewController = vc
        vc.inject(ui: ui, presenter: presenter, routing: routing, disposeBag: DisposeBag())
        vc.recieve(with: token)
        return vc
    }
    
    func createCompleteController() -> UIViewController {
        let repository = GoalRepositoryImpl.shared
        let useCase = GoalPostUseCaseImpl(repository: repository)
        let presenter = PrivateCompletePresenterImpl(useCase: useCase)
        let vc = PrivateCompleteViewController()
        
        let ui = PrivateCompleteUIImpl()
        let routing = PrivateCompleteRoutingImpl()
        ui.viewController = vc
        ui.timeline.dataSource = vc.dataSource
        ui.timeline.delegate = presenter
        routing.viewController = vc
        vc.inject(ui: ui, presenter: presenter, routing: routing, disposeBag: DisposeBag())
        vc.recieve(with: token)
        return vc
    }
    
    func createDraftController() -> UIViewController {
        let repository = GoalRepositoryImpl.shared
        let useCase = GoalPostUseCaseImpl(repository: repository)
        let presenter = PrivateDraftPresenterImpl(useCase: useCase)
        let vc = PrivateDraftViewController()
        
        let ui = PrivateDraftUIImpl()
        let routing = PrivateDraftRoutingImpl()
        ui.viewController = vc
        ui.timeline.dataSource = vc.dataSource
        ui.timeline.delegate = presenter
        routing.viewController = vc
        vc.inject(ui: ui, presenter: presenter, routing: routing, disposeBag: DisposeBag())
        vc.recieve(with: token)
        return vc
    }
    
    func createAllController() -> UIViewController {
        let repository = GoalRepositoryImpl.shared
        let useCase = GoalPostUseCaseImpl(repository: repository)
        let presenter = PrivateAllPresenterImpl(useCase: useCase)
        let vc = PrivateAllViewController()
        
        let ui = PrivateAllUIImpl()
        let routing = PrivateAllRoutingImpl()
        ui.viewController = vc
        ui.timeline.dataSource = vc.dataSource
        ui.timeline.delegate = presenter
        routing.viewController = vc
        vc.inject(ui: ui, presenter: presenter, routing: routing, disposeBag: DisposeBag())
        vc.recieve(with: token)
        return vc
    }
}
