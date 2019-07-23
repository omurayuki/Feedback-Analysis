import Foundation
import UIKit
import RxSwift
import RxCocoa

class FollowListViewController: UIViewController {
    
    typealias DataSource = TableViewDataSource<FollowListCell, User>
    
    private(set) lazy var dataSource: DataSource = {
        return DataSource(cellReuseIdentifier: String(describing: FollowListCell.self),
                          listItems: [],
                          isSkelton: false,
                          cellConfigurationHandler: { (cell, user, indexPath) in
            cell.content = user
        })
    }()
    
    var followQueryRef: FirebaseQueryRef!
    
    var ui: FollowListUI!
    
    var routing: FollowListRouting!
    
    var presenter: FollowListPresenter! {
        didSet {
            presenter.view = self
        }
    }
    
    var disposeBag: DisposeBag! {
        didSet {
            presenter.isLoading
                .subscribe(onNext: { [unowned self] isLoading in
                    self.view.endEditing(true)
                    self.setIndicator(show: isLoading)
                }).disposed(by: disposeBag)
        }
    }
    
    private var tmpObjectToken = String()
    
    init(followQueryRef: FirebaseQueryRef) {
        self.followQueryRef = followQueryRef
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    func inject(ui: FollowListUI,
                presenter: FollowListPresenter,
                routing: FollowListRouting,
                disposeBag: DisposeBag) {
        self.ui = ui
        self.presenter = presenter
        self.routing = routing
        self.disposeBag = disposeBag
        
        self.presenter.fetch(from: followQueryRef, loading: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //// otherPageに行く際, setObjectTokenに新しいuserのtokenがsetさせて戻ってくる際にそのuserのfollowListが表示される
        //// それを回避するためにtmpObjectTokenという一時的な変数に現在のuserのTokenを保存して、otherPageから戻ってくる際にその変数をsetObjectTokenに渡して回避
        followQueryRef.isMypage ? () : AppUserDefaults.setObjectToken(token: tmpObjectToken)
        //// otherPersonPageの先に別のuserのfollowListを参照すればuserdefaultsが書き換えられるので戻ってきた際にもう一度fetchしてuserdefaultsに保存
        ui.followList.isUserInteractionEnabled = false
        presenter.fetch(from: followQueryRef, loading: presenter.isFirstLoading) {
            self.presenter.isFirstLoading = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ui.setup()
    }
}

extension FollowListViewController: FollowListPresenterView {
    
    func updateLoading(_ isLoading: Bool) {
        presenter.isLoading.accept(isLoading)
    }
    
    func didFetchUsersData(users: [User]) {
        dataSource.listItems = []
        dataSource.listItems += users
        followQueryRef.isFollow
            ? (presenter.setFolloweeTokens(users.compactMap { $0.userToken }))
            : (presenter.setFollowerTokens(users.compactMap { $0.userToken }))
        ui.followList.isUserInteractionEnabled = true
        ui.followList.reloadData()
    }
    
    func didSelect(indexPath: IndexPath, tableView: UITableView) {
        followQueryRef.isFollow
            ? (presenter.getFolloweeToken(indexPath.row))
            : (presenter.getFollowerToken(indexPath.row))
    }
    
    func didRecieveUserToken(token: String) {
        followQueryRef.isMypage ? () : (tmpObjectToken = AppUserDefaults.getObjectToken())
        routing.showOtherPersonPage(with: token)
    }
}
