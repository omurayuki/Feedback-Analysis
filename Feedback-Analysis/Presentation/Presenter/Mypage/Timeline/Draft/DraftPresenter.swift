import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol DraftPresenter {
    var view: DraftPresenterView! { get set }
    var isLoading: BehaviorRelay<Bool> { get }
    
    func fetch(from queryRef: FirebaseQueryRef, completion: (() -> Void)?)
}

protocol DraftPresenterView: class {
    var disposeBag: DisposeBag! { get }
    
    func inject(ui: DraftUI,
                presenter: DraftPresenter,
                routing: DraftRouting,
                disposeBag: DisposeBag)
    func didFetchGoalData(timeline: [Timeline])
    func didSelect(row index: Int)
    func showError(message: String)
    func updateLoading(_ isLoading: Bool)
}
