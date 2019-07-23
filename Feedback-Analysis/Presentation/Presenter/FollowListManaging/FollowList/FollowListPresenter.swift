import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol FollowListPresenter: Presenter {
    var view: FollowListPresenterView! { get set }
    var isLoading: BehaviorRelay<Bool> { get }
    var isFirstLoading: Bool { get set }
    
    func fetch(from queryRef: FirebaseQueryRef, loading: Bool, completion: (() -> Void)?)
    func setFolloweeTokens(_ values: [String])
    func setFollowerTokens(_ values: [String])
    func getFolloweeToken(_ index: Int)
    func getFollowerToken(_ index: Int)
}

protocol FollowListPresenterView: class {
    var disposeBag: DisposeBag! { get }
    
    func inject(ui: FollowListUI,
                presenter: FollowListPresenter,
                routing: FollowListRouting,
                disposeBag: DisposeBag)
    func didFetchUsersData(users: [User])
    func didSelect(indexPath: IndexPath, tableView: UITableView)
    func didRecieveUserToken(token: String)
    func showError(message: String)
    func updateLoading(_ isLoading: Bool)
}
