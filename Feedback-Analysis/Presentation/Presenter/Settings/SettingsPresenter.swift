import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol SettingsPresenter: Presenter {
    var view: SettingsPresenterView! { get set }
    
    func logout()
}

protocol SettingsPresenterView: class {
    var disposeBag: DisposeBag! { get }
    
    func inject(ui: SettingsUI,
                presenter: SettingsPresenter,
                routing: SettingsRouting,
                disposeBag: DisposeBag)
    func didLogoutSuccess()
    func showError(message: String)
}
