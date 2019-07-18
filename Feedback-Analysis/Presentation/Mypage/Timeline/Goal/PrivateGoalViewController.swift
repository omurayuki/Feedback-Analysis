import Foundation
import UIKit
import RxSwift
import RxCocoa
import FirebaseFirestore

class PrivateGoalViewController: UIViewController {
    
    typealias DataSource = TableViewDataSource<TimelineCell, Timeline>
    
    private(set) lazy var dataSource: DataSource = {
        return DataSource(cellReuseIdentifier: String(describing: TimelineCell.self),
                          listItems: [],
                          isSkelton: false,
                          cellConfigurationHandler: { (cell, item, indexPath) in
            cell.cellTapDelegate = self
            cell.identificationId = indexPath.row
            cell.content = item
        })
    }()
    
    var ui: PrivateTimelineContentUI!
    
    var routing: PrivateGoalRouting!
    
    var presenter: PrivateGoalPresenter! {
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
    
    func inject(ui: PrivateTimelineContentUI,
                presenter: PrivateGoalPresenter,
                routing: PrivateGoalRouting,
                disposeBag: DisposeBag) {
        self.ui = ui
        self.presenter = presenter
        self.routing = routing
        self.disposeBag = disposeBag
        
        self.presenter.getAuthorToken(completion: { [unowned self] token in
            self.presenter.fetch(from: .goalRef(authorToken: token), completion: nil)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ui.setup()
    }
}

extension PrivateGoalViewController: PrivateGoalPresenterView {
    
    func updateLoading(_ isLoading: Bool) {
        presenter.isLoading.accept(isLoading)
    }
    
    func didFetchGoalData(timeline: [Timeline]) {
        dataSource.listItems = []
        dataSource.listItems += timeline
        ui.timeline.reloadData()
    }
    
    func didSelect(indexPath: IndexPath, tableView: UITableView) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let height = tableView.cellForRow(at: indexPath)?.contentView.frame.height else { return }
        routing.showDetail(with: dataSource.listItems[indexPath.row], height: height + 2)
    }
    
    func didCheckIfYouLiked(_ bool: Bool) {
        switch bool {
        case false:
            presenter.getSelected { [unowned self] index in
                self.updateLikeCount(index: index, count: 1)
                self.presenter.getAuthorToken(completion: { [unowned self] token in
                    self.presenter.create(documentRef: .likeUserRef(goalDocument: self.dataSource.listItems[index].documentId,
                                                                    authorToken: token), value: [:])
                })
            }
        case true:
            presenter.getSelected { [unowned self] index in
                self.updateLikeCount(index: index, count: -1)
                self.presenter.getAuthorToken(completion: { [unowned self] token in
                    self.presenter.delete(documentRef: .likeUserRef(goalDocument: self.dataSource.listItems[index].documentId,
                                                                    authorToken: token))
                })
            }
        }
    }
    
    func didCreateLikeRef() {
        presenter.getSelected { [unowned self] index in
            self.presenter.update(to: .goalUpdateRef(author_token: self.dataSource.listItems[index].authorToken,
                                                     goalDocument: self.dataSource.listItems[index].documentId),
                                  value: ["like_count": FieldValue.increment(1.0)])
        }
    }
    
    func didDeleteLikeRef() {
        presenter.getSelected { [unowned self] index in
            self.presenter.update(to: .goalUpdateRef(author_token: self.dataSource.listItems[index].authorToken,
                                                     goalDocument: self.dataSource.listItems[index].documentId),
                                  value: ["like_count": FieldValue.increment(-1.0)])
        }
    }
}

extension PrivateGoalViewController {
    
    func updateLikeCount(index: Int, count: Int) {
        dataSource.listItems[index].likeCount += count
        ui.timeline.reloadData()
    }
}

extension PrivateGoalViewController: CellTapDelegate {
    
    func tappedLikeBtn(index: Int) {
        self.presenter.getAuthorToken(completion: { [unowned self] token in
            self.presenter.get(documentRef: .likeUserRef(goalDocument: self.dataSource.listItems[index].documentId,
                                                         authorToken: token))
            self.presenter.setSelected(index: index)
        })
    }
}
