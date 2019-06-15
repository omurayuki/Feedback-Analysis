import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol EditPresenter: Presenter {
    var view: EditPresenterView! { get set }
    var isLoading: BehaviorRelay<Bool> { get }
    
    func update(to documentRef: FirebaseDocumentRef, user: Update)
}

protocol EditPresenterView: class {
    var disposeBag: DisposeBag! { get }
    
    func inject(ui: EditUI,
                presenter: EditPresenter,
                routing: EditRouting,
                disposeBag: DisposeBag,
                user: UpdatingItem)
    func showError(message: String)
    func didEditUserData()
    func updateLoading(_ isLoading: Bool)
}
