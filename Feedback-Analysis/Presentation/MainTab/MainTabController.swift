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
        let repository = MypageRepositoryImpl.shared
        let useCase = MypageUseCaseImpl(repository: repository)
        let presenter = MypagePresenterImpl(useCase: useCase)
        let vc = MypageViewController()
        
        let ui = MypageUIImpl()
        let routing = MypageRoutingImpl()
        ui.viewController = vc
        ui.timelineTable.dataSource = vc
        ui.timelineTable.delegate = vc
        ui.timelineSegmented.delegate = vc
        routing.viewController = vc
        vc.inject(ui: ui,
                  presenter: presenter,
                  routing: routing,
                  disposeBag: DisposeBag())
        
        return vc
    }
}
