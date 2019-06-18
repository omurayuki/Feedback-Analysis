import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol EmailEditingPresenter: Presenter {
    var view: EmailEditingPresenterView! { get set }
    
    var isLoading: BehaviorRelay<Bool> { get }
    
    func update(with email: String)
}

protocol EmailEditingPresenterView: class {
    var disposeBag: DisposeBag! { get }
    
    func inject(ui: EmailEditingUI,
                routing: EmailEditingRouting,
                presenter: EmailEditingPresenter,
                disposeBag: DisposeBag)
    func showError(message: String)
    func showSuccess(message: String)
    func updateLoading(_ isLoading: Bool)
}
