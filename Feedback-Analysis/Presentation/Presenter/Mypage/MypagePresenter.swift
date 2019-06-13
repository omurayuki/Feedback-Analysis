import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol MypagePresenter: Presenter {
    var view: MypagePresenterView! { get set }
    
    var isLoading: BehaviorRelay<Bool> { get }
}

protocol MypagePresenterView: class {
    var disposeBag: DisposeBag! { get }
    
    func inject(ui: MypageUI,
                presenter: MypagePresenter,
                routing: MypageRouting,
                disposeBag: DisposeBag)
    func didLoginSuccess(account: Account)
    func showError(message: String)
    func updateLoading(_ isLoading: Bool)
}
