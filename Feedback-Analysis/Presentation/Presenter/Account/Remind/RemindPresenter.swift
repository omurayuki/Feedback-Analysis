import Foundation
import RxSwift
import RxCocoa

protocol RemindPresenter: Presenter {
    var view: RemindPresenterView! { get set }
    var isLoading: BehaviorRelay<Bool> { get }
    
    func reissuePassword(email: String)
}

protocol RemindPresenterView: class {
    var disposeBag: DisposeBag! { get }
    
    func inject(ui: RemindUI,
                presenter: RemindPresenter,
                disposeBag: DisposeBag,
                routing: RemindRouting)
    func didSubmitSuccess()
    func showError(message: String)
    func updateLoading(_ isLoading: Bool)
}
