import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol AllPresenter {
    var view: AllPresenterView! { get set }
    var isLoading: BehaviorRelay<Bool> { get }
    
    func fetch(from queryRef: FirebaseQueryRef, completion: (() -> Void)?)
}

protocol AllPresenterView: class {
    var disposeBag: DisposeBag! { get }
    
    func inject(ui: AllUI,
                presenter: AllPresenter,
                routing: AllRouting,
                disposeBag: DisposeBag)
    func didFetchGoalData(timeline: [Timeline])
    func didSelect(row index: Int)
    func showError(message: String)
    func updateLoading(_ isLoading: Bool)
}
