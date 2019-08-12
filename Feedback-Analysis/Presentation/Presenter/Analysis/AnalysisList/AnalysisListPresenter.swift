import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol AnalysisListPresenter {
    var view: AnalysisListPresenterView! { get set }
    var isLoading: BehaviorRelay<Bool> { get }
    var isFirstLoading: Bool { get set }
    
    func fetch(from queryRef: FirebaseQueryRef, loading: Bool, completion: (() -> Void)?)
}

protocol AnalysisListPresenterView: class {
    var disposeBag: DisposeBag! { get }
    
    func inject(ui: AnalysisListUI,
                presenter: AnalysisListPresenter,
                routing: AnalysisListRouting,
                disposeBag: DisposeBag)
    func didFetchGoalData(timeline: [Timeline])
    func didSelect(indexPath: IndexPath, tableView: UITableView)
    func showError(message: String)
    func updateLoading(_ isLoading: Bool)
}
