import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol CompletePresenter {
    var view: CompletePresenterView! { get set }
    var isLoading: BehaviorRelay<Bool> { get }
    
    func fetch(from queryRef: FirebaseQueryRef, completion: (() -> Void)?)
}

protocol CompletePresenterView: class {
    var disposeBag: DisposeBag! { get }
    
    func inject(ui: CompleteUI,
                presenter: CompletePresenter,
                routing: CompleteRouting,
                disposeBag: DisposeBag)
    func didFetchGoalData(timeline: [Timeline])
    func didSelect(row index: Int)
    func showError(message: String)
    func updateLoading(_ isLoading: Bool)
}
