import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol AllPresenter {
    var view: AllPresenterView! { get set }
    var isLoading: BehaviorRelay<Bool> { get }
    
    func fetch(from queryRef: FirebaseQueryRef, completion: (() -> Void)?)
    func update(to documentRef: FirebaseDocumentRef, value: [String: Any])
    func get(documentRef: FirebaseDocumentRef)
    func create(documentRef: FirebaseDocumentRef, value: [String: Any])
    func delete(documentRef: FirebaseDocumentRef)
}

protocol AllPresenterView: class {
    var disposeBag: DisposeBag! { get }
    
    func inject(ui: AllUI,
                presenter: AllPresenter,
                routing: AllRouting,
                disposeBag: DisposeBag)
    func didFetchGoalData(timeline: [Timeline])
    func didSelect(indexPath: IndexPath, tableView: UITableView)
    func didCheckIfYouLiked(_ bool: Bool)
    func didCreateLikeRef()
    func didDeleteLikeRef()
    func showError(message: String)
    func updateLoading(_ isLoading: Bool)
}
