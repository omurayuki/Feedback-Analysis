import Foundation
import UIKit
import RxSwift

protocol MypageRouting: Routing {
    func moveEditPage(user: UpdatingItem)
    func moveSettingsPage()
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
        ui.settingsTable.delegate = vc
        routing.viewController = vc
        
        vc.inject(ui: ui,
                  presenter: presenter,
                  routing: routing,
                  disposeBag: DisposeBag())
        
        viewController?.present(UINavigationController(rootViewController: vc), animated: true)
    }
}
