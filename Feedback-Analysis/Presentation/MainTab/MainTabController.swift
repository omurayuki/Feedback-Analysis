import Foundation
import UIKit
import RxSwift

class MainTabController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

extension MainTabController {
    private func setup() {
        tabBar.barStyle = .default
        tabBar.clipsToBounds = true
        
        var resouces = [#imageLiteral(resourceName: "diary"), #imageLiteral(resourceName: "bell"), #imageLiteral(resourceName: "mail"), #imageLiteral(resourceName: "home")]
        var viewControllers: [UIViewController] = []
        
        [initMypageVC(), initMypageVC(), initMypageVC(), initMypageVC()].enumerated().forEach { index, controller in
            let navi = UINavigationController(rootViewController: controller)
            navi.tabBarItem = UITabBarItem(title: nil, image: resouces[index], tag: index)
            
            viewControllers.append(navi)
        }
        
        setViewControllers(viewControllers, animated: false)
        selectedIndex = 0
    }
    
    private func initMypageVC() -> MypageViewController {
        let controllers = [createGoalController(), createCompleteController(),
                           createDraftController(), createIineController()]
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
    
    private func createGoalController() -> UIViewController {
        let repository = GoalRepositoryImpl.shared
        let useCase = GoalPostUseCaseImpl(repository: repository)
        let presenter = GoalPresenterImpl(useCase: useCase)
        let vc = GoalViewController()
        
        let ui = GoalUIImpl()
        let routing = GoalRoutingImpl()
        ui.viewController = vc
        ui.timeline.dataSource = vc.dataSource
        routing.viewController = vc
        vc.inject(ui: ui, presenter: presenter, routing: routing, disposeBag: DisposeBag())
        return vc
    }
    
    private func createCompleteController() -> UIViewController {
        let completeVC = UIViewController()
        completeVC.view.backgroundColor = .white
        return completeVC
    }
    
    private func createDraftController() -> UIViewController {
        let draftVC = UIViewController()
        draftVC.view.backgroundColor = .blue
        return draftVC
    }
    
    private func createIineController() -> UIViewController {
        let iineVC = UIViewController()
        iineVC.view.backgroundColor = .green
        return iineVC
    }
}
