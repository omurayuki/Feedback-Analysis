import Foundation
import UIKit
import RxSwift
import RxCocoa
import FirebaseFirestore

class CompleteViewController: UIViewController {
    
    typealias DataSource = TableViewDataSource<TimelineCell, Timeline>
    
    private(set) lazy var dataSource: DataSource = {
        return DataSource(cellReuseIdentifier: String(describing: TimelineCell.self),
                          listItems: [],
                          cellConfigurationHandler: { (cell, item, _) in
            cell.delegate = self
            cell.content = item
        })
    }()
    
    var ui: CompleteUI!
    
    var routing: CompleteRouting!
    
    var presenter: CompletePresenter! {
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
    
    func inject(ui: CompleteUI,
                presenter: CompletePresenter,
                routing: CompleteRouting,
                disposeBag: DisposeBag) {
        self.ui = ui
        self.presenter = presenter
        self.routing = routing
        self.disposeBag = disposeBag
        
        self.presenter.fetch(from: .completeRef, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ui.setup()
    }
}

extension CompleteViewController: CompletePresenterView {
    
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
        routing.showDetail(with: dataSource.listItems[indexPath.row], height: height)
    }
    
    func didCheckIfYouLiked(_ bool: Bool) {
        switch bool {
        case false:
            presenter.getSelected { index in
                self.presenter.create(documentRef: .likeUserRef(goalDocument: self.dataSource.listItems[index].documentId), value: [:])
            }
        case true:
            presenter.getSelected { index in
                self.presenter.delete(documentRef: .likeUserRef(goalDocument: self.dataSource.listItems[index].documentId))
            }
        }
    }
    
    func didCreateLikeRef() {
        presenter.getSelected { index in
            self.presenter.update(to: .goalUpdateRef(author_token: self.dataSource.listItems[index].authorToken,
                                                     goalDocument: self.dataSource.listItems[index].documentId),
                                  value: ["like_count": FieldValue.increment(1.0)])
        }
    }
    
    func didDeleteLikeRef() {
        presenter.getSelected { index in
            self.presenter.update(to: .goalUpdateRef(author_token: self.dataSource.listItems[index].authorToken,
                                                     goalDocument: self.dataSource.listItems[index].documentId),
                                  value: ["like_count": FieldValue.increment(-1.0)])
        }
    }
}

extension CompleteViewController: CellTapDelegate {
    
    func tappedLikeBtn(index: Int) {
        presenter.get(documentRef: .likeUserRef(goalDocument: dataSource.listItems[index].documentId))
        presenter.setSelected(index: index)
    }
}
