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
        
        var resouces = [#imageLiteral(resourceName: "iconfinder_news_216342"), #imageLiteral(resourceName: "iconfinder_film_216198"), #imageLiteral(resourceName: "iconfinder_mail_216294"), #imageLiteral(resourceName: "iconfinder_home-outline_216240")]
        var titles = ["TIMELINE", "ANALYSIS", "CHAT", "MYPAGE"]
        var viewControllers: [UIViewController] = []
        
        [initTimelineVC(), initAnalysisVC(), initConversationVC(), initMypageVC(with: AppUserDefaults.getAuthToken())].enumerated().forEach { index, controller in
            let navi = UINavigationController(rootViewController: controller)
            navi.tabBarItem = UITabBarItem(title: titles[index], image: resouces[index], tag: index)
            
            viewControllers.append(navi)
        }
        
        setViewControllers(viewControllers, animated: false)
        selectedIndex = 0
    }
    
    private func initTimelineVC() -> TimelineViewController {
        let controllers = [cretePublicGoalController(),
                           cretePublicCompleteController()]
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
        ui.timelinePages.delegate = presenter
        vc.inject(ui: ui,
                  presenter: presenter,
                  routing: routing,
                  viewControllers: controllers,
                  disposeBag: DisposeBag())
        
        ui.timelinePages.dataSource = vc.dataSource
        
        return vc
    }
    
    private func initAnalysisVC() -> AnalysisWrapViewController {
        let controllers = [createAnalysisResultController(),
                           createAnalysisListController()]
        controllers.enumerated().forEach { index, controller in controller.view.tag = index }
        let repository = TimelineRepositoryImpl.shared
        let useCase = TimelineUseCaseImpl(repository: repository)
        let presenter = AnalysisWrapPresenterImpl(useCase: useCase)
        let vc = AnalysisWrapViewController()
        
        let ui = AnalysisWrapUIImpl()
        let routing = AnalysisWrapRoutingImpl()
        ui.viewController = vc
        routing.viewController = vc
        ui.segmented.delegate = presenter
        ui.pages.delegate = presenter
        vc.inject(ui: ui,
                  presenter: presenter,
                  routing: routing,
                  viewControllers: controllers,
                  disposeBag: DisposeBag())
        
        ui.pages.dataSource = vc.dataSource
        
        return vc
    }
    
    private func initConversationVC() -> ConversationViewController {
        let repository = ConversationRepositoryImpl.shared
        let useCase = ConversationUseCaseImpl(repository: repository)
        let presenter = ConversationPresenterImpl(useCase: useCase)
        let vc = ConversationViewController()
        
        let ui = ConversationUIImpl()
        let routing = ConversationRoutingImpl()
        ui.viewController = vc
        routing.viewController = vc
        ui.tableView.dataSource = vc.dataSource
        ui.tableView.delegate = presenter
        vc.inject(ui: ui,
                  presenter: presenter,
                  routing: routing,
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
        ui.timelinePages.delegate = presenter
        routing.viewController = vc
        vc.inject(ui: ui,
                  presenter: presenter,
                  routing: routing,
                  viewControllers: controllers,
                  disposeBag: DisposeBag())
        //// injectでcontrollersをセットしてからじゃないと、dataSourceの初期化内のcontrollersがnilになって落ちる
        ui.timelinePages.dataSource = vc.dataSource
        
        return vc
    }
}

extension MainTabController {
    
    func cretePublicGoalController() -> UIViewController {
        let repository = TimelineRepositoryImpl.shared
        let useCase = TimelineUseCaseImpl(repository: repository)
        let presenter = PublicTimelineContentPresenterImpl(useCase: useCase)
        let vc = PublicGoalViewController()
        
        let ui = PublicTimelineContentUIImpl()
        let routing = PublicTimelineContentRoutingImpl()
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
        let presenter = PublicTimelineContentPresenterImpl(useCase: useCase)
        let vc = PublicCompleteViewController()
        
        let ui = PublicTimelineContentUIImpl()
        let routing = PublicTimelineContentRoutingImpl()
        ui.viewController = vc
        ui.timeline.dataSource = vc.dataSource
        ui.timeline.delegate = presenter
        routing.viewController = vc
        vc.inject(ui: ui, presenter: presenter, routing: routing, disposeBag: DisposeBag())
        return vc
    }
}

extension MainTabController {
    
    func createAnalysisResultController() -> UIViewController {
        let repository = TimelineRepositoryImpl.shared
        let useCase = TimelineUseCaseImpl(repository: repository)
        let presenter = AnalysisResultPresenterImpl(useCase: useCase)
        let routing = AnalysisResultRoutingImpl()
        let sb = UIStoryboard(name: "AnalysisResult", bundle: nil)
        guard
            let vc = sb.instantiateViewController(withIdentifier: "AnalysisResultViewControllor") as? AnalysisResultViewControllor
        else {
            return UIViewController()
        }
        let _ = vc.view
        routing.viewController = vc
        vc.analysisTableView.dataSource = vc.dataSource
        vc.analysisTableView.delegate = presenter
        vc.pieChart.delegate = presenter
        vc.inject(presenter: presenter,
                  routing: routing,
                  disposeBag: DisposeBag())
        return vc
    }
    
    func createAnalysisListController() -> UIViewController {
        let repository = TimelineRepositoryImpl.shared
        let useCase = TimelineUseCaseImpl(repository: repository)
        let presenter = AnalysisListPresenterImpl(useCase: useCase)
        let vc = AnalysisListViewController()
        
        let ui = AnalysisListUIImpl()
        let routing = AnalysisListRoutingImpl()
        ui.viewController = vc
        routing.viewController = vc
        ui.tableView.dataSource = vc.dataSource
        ui.tableView.delegate = presenter
        vc.inject(ui: ui,
                  presenter: presenter,
                  routing: routing,
                  disposeBag: DisposeBag())
        
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
        let presenter = PrivateTimelineContentPresenterImpl(useCase: useCase)
        let vc = PrivateGoalViewController(recieveToken: token)
        
        let ui = PrivateTimelineContentUIImpl()
        let routing = PrivateTimelineContentRoutingImpl()
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
        let presenter = PrivateTimelineContentPresenterImpl(useCase: useCase)
        let vc = PrivateCompleteViewController(recieveToken: token)
        
        let ui = PrivateTimelineContentUIImpl()
        let routing = PrivateTimelineContentRoutingImpl()
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
        let presenter = PrivateTimelineContentPresenterImpl(useCase: useCase)
        let vc = PrivateDraftViewController()
        
        let ui = PrivateTimelineContentUIImpl()
        let routing = PrivateTimelineContentRoutingImpl()
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
        let presenter = PrivateTimelineContentPresenterImpl(useCase: useCase)
        let vc = PrivateAllViewController(recieveToken: token)
        
        let ui = PrivateTimelineContentUIImpl()
        let routing = PrivateTimelineContentRoutingImpl()
        ui.viewController = vc
        ui.timeline.dataSource = vc.dataSource
        ui.timeline.delegate = presenter
        routing.viewController = vc
        vc.inject(ui: ui, presenter: presenter, routing: routing, disposeBag: DisposeBag())
        vc.recieve(with: token)
        return vc
    }
}
