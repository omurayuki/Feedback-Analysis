import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol GoalPresenter {
    var view: GoalPresenterView! { get set }
    var isLoading: BehaviorRelay<Bool> { get }
    
    func fetch(from queryRef: FirebaseQueryRef, completion: (() -> Void)?)
    func update(to documentRef: FirebaseDocumentRef, value: [String: Any])
}

protocol GoalPresenterView: class {
    var disposeBag: DisposeBag! { get }
    
    func inject(ui: GoalUI,
                presenter: GoalPresenter,
                routing: GoalRouting,
                disposeBag: DisposeBag)
    func didFetchGoalData(timeline: [Timeline])
    func didSelect(indexPath: IndexPath, tableView: UITableView)
    func showError(message: String)
    func updateLoading(_ isLoading: Bool)
}
