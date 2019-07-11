import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol EmailEditingPresenter: Presenter {
    var view: EmailEditingPresenterView! { get set }
    
    var isLoading: BehaviorRelay<Bool> { get }
    
    func update(with email: String)
    func getEmail()
}

protocol EmailEditingPresenterView: class {
    var disposeBag: DisposeBag! { get }
    
    func inject(ui: EmailEditingUI,
                routing: EmailEditingRouting,
                presenter: EmailEditingPresenter,
                disposeBag: DisposeBag)
    func didGet(with email: String)
    func showError(message: String)
    func showSuccess(message: String)
    func updateLoading(_ isLoading: Bool)
}
