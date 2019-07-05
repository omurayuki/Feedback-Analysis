import Foundation
import UIKit
import RxSwift
import RxCocoa
import FirebaseFirestore

class DraftViewController: UIViewController {
    
    typealias DataSource = TableViewDataSource<TimelineCell, Timeline>
    
    private(set) lazy var dataSource: DataSource = {
        return DataSource(cellReuseIdentifier: String(describing: TimelineCell.self),
                          listItems: [],
                          cellConfigurationHandler: { (cell, item, _) in
            cell.delegate = self
            cell.content = item
        })
    }()
    
    var ui: DraftUI!
    
    var routing: DraftRouting!
    
    var presenter: DraftPresenter! {
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
    
    func inject(ui: DraftUI,
                presenter: DraftPresenter,
                routing: DraftRouting,
                disposeBag: DisposeBag) {
        self.ui = ui
        self.presenter = presenter
        self.routing = routing
        self.disposeBag = disposeBag
        
        self.presenter.fetch(from: .draftRef, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ui.setup()
    }
}

extension DraftViewController: DraftPresenterView {
    
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
}

extension DraftViewController: CellTapDelegate {
    
    func tappedLikeBtn(index: Int) {
        if dataSource.listItems[index].likeCount <= 0 {
            presenter.update(to: .goalUpdateRef(author_token: dataSource.listItems[index].authorToken, goalDocument: dataSource.listItems[index].documentId),
                             value: ["like_count": FieldValue.increment(1.0)])
        } else {
            presenter.update(to: .goalUpdateRef(author_token: dataSource.listItems[index].authorToken, goalDocument: dataSource.listItems[index].documentId),
                             value: ["like_count": FieldValue.increment(-1.0)])
        }
    }
}
