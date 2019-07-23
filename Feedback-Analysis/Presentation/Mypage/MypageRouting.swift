import Foundation
import UIKit
import RxSwift

protocol MypageRouting: Routing {
    func moveEditPage()
    func moveSettingsPage()
    func moveGoalPostPage()
    func showFollowListPage()
}

final class MypageRoutingImpl: MypageRouting {
    
    var viewController: UIViewController?
    
    func moveEditPage() {
        let repository = MypageRepositoryImpl.shared
        let useCase = EditUseCaseImpl(repository: repository)
        let presenter = EditPresenterImpl(useCase: useCase)
        let vc = EditViewController()
        
        let ui = EditUIImpl()
        let routing = EditRoutingImpl()
        vc.delegate = viewController as? MypageViewController
        ui.viewController = vc
        routing.viewController = vc
        let imagePicker = ImagePicker(presentationController: vc, delegate: vc as ImagePickerDelegate)
        
        vc.inject(ui: ui,
                  presenter: presenter,
                  routing: routing,
                  disposeBag: DisposeBag(),
                  imagePicker: imagePicker)
        
        viewController?.present(vc, animated: true)
    }
    
    func moveSettingsPage() {
        let repository = AccountRepositoryImpl.shared
        let useCase = SettingsUseCaseImpl(repository: repository)
        let presenter = SettingsPresenterImpl(useCase: useCase)
        let vc = SettingsViewController()
        
        let ui = SettingsUIImpl()
        let routing = SettingsRoutingImpl()
        ui.viewController = vc
        ui.settingsTable.dataSource = vc
        ui.settingsTable.delegate = presenter
        routing.viewController = vc
        
        vc.inject(ui: ui,
                  presenter: presenter,
                  routing: routing,
                  disposeBag: DisposeBag())
        
        viewController?.present(UINavigationController(rootViewController: vc), animated: true)
    }
    
    func moveGoalPostPage() {
        let repository = GoalRepositoryImpl.shared
        let useCase = GoalPostUseCaseImpl(repository: repository)
        let presenter = GoalPostPresenterImpl(useCase: useCase)
        let vc = GoalPostViewController()
        
        let ui = GoalPostUIImpl()
        let routing = GoalPostRoutingImpl()
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
    
    func showFollowListPage() {
        let vc1 = createFollowListViewController(queryRef: .followeeRefFromMypage)
        let vc2 = createFollowerListViewController(queryRef: .followerRefFromMypage)
        let controllers = [vc1, vc2]
        controllers.enumerated().forEach { index, controller in controller.view.tag = index }
        let repository = FollowRepositoryImpl.shared
        let useCase = FollowUseCaseImpl(repository: repository)
        let presenter = FollowListManagingPresenterImpl(useCase: useCase)
        let vc = FollowListManagingViewController()
        
        let ui = FollowListManagingUIImpl()
        let routing = FollowListManagingRoutingImpl()
        ui.viewController = vc
        routing.viewController = vc
        ui.followSegment.delegate = presenter
        ui.followPages.dataSource = vc
        ui.followPages.delegate = presenter
        vc.inject(ui: ui,
                  presenter: presenter,
                  routing: routing,
                  viewControllers: controllers,
                  disposeBag: DisposeBag())
        
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
