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
        presenter.setAuthorTokens(users.compactMap { $0.userToken })
        ui.followList.reloadData()
        ui.refControl.endRefreshing()
    }
    
    func didSelect(indexPath: IndexPath, tableView: UITableView) {
        presenter.getAuthorToken(indexPath.row) { [unowned self] token in
            self.routing.showOtherPersonPage(with: token)
        }
    }
}
