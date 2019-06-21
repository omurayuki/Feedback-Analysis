import Foundation
import UIKit
import RxSwift

protocol MypageRouting: Routing {
    func moveEditPage(user: UpdatingItem)
    func moveSettingsPage()
    func moveGoalPostPage()
}

final class MypageRoutingImpl: MypageRouting {
    
    var viewController: UIViewController?
    
    func moveEditPage(user: UpdatingItem) {
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
                  user: user,
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
}
