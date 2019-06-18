import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol PasswordEditingPresenter: Presenter {
    var view: PasswordEditingPresenterView! { get set }
    
    var isLoading: BehaviorRelay<Bool> { get }
    
    func update(with email: String, oldPass: String, newPass: String)
}

protocol PasswordEditingPresenterView: class {
    var disposeBag: DisposeBag! { get }
    
    func inject(ui: PasswordEditingUI,
                routing: PasswordEditingRouting,
                presenter: PasswordEditingPresenter,
                disposeBag: DisposeBag)
    func showError(message: String)
    func showSuccess(message: String)
    func updateLoading(_ isLoading: Bool)
}
