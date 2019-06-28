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
        let sample1 = createController()
        let sample2 = UIViewController()
        sample2.view.backgroundColor = .white
        let sample3 = UIViewController()
        sample3.view.backgroundColor = .blue
        let sample4 = UIViewController()
        sample4.view.backgroundColor = .gray
        [sample1, sample2, sample3, sample4].enumerated().forEach { index, controller in controller.view.tag = index }
        
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
                  viewControllers: [sample1, sample2, sample3, sample4],
                  disposeBag: DisposeBag())
        
        return vc
    }
    
    func createController() -> UIViewController {
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
}
