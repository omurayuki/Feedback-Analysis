import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol FollowListPresenter: Presenter {
    var view: FollowListPresenterView! { get set }
    var isLoading: BehaviorRelay<Bool> { get }
    var isFiestLoading: Bool { get set }
    
    func fetch(from queryRef: FirebaseQueryRef, loading: Bool, completion: (() -> Void)?)
    func setAuthorTokens(_ values: [String])
    func getAuthorToken(_ index: Int, completion: @escaping (String) -> Void)
}

protocol FollowListPresenterView: class {
    var disposeBag: DisposeBag! { get }
    
    func inject(ui: FollowListUI,
                presenter: FollowListPresenter,
                routing: FollowListRouting,
                disposeBag: DisposeBag)
    func didFetchUsersData(users: [User])
    func didSelect(indexPath: IndexPath, tableView: UITableView)
    func showError(message: String)
    func updateLoading(_ isLoading: Bool)
}
