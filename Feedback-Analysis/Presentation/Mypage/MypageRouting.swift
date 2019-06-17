import Foundation
import UIKit
import RxSwift

protocol MypageRouting: Routing {
    func moveEditPage(user: UpdatingItem)
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
}
