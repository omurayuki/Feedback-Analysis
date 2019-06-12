import Foundation
import RxSwift
import RxCocoa

protocol LoginInputPresenter {
    
    var view: LoginInputPresenterView! { get set }
    
    var isLoading: BehaviorRelay<Bool> { get }
    
    func login(email: String, pass: String)
}

protocol LoginInputPresenterView: class {
    var disposeBag: DisposeBag! { get }
    
    func inject(ui: LoginInputUI,
                presenter: LoginInputPresenter,
                disposeBag: DisposeBag,
                routing: LoginInputRouting)
    func didLoginSuccess(account: Account)
    func showError(message: String)
    func updateLoading(_ isLoading: Bool)
}
