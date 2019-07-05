import Foundation
import UIKit
import RxSwift
import RxCocoa
import FirebaseFirestore

class GoalViewController: UIViewController {
    
    private var didSelectIndex = Int()
    
    typealias DataSource = TableViewDataSource<TimelineCell, Timeline>
    
    private(set) lazy var dataSource: DataSource = {
        return DataSource(cellReuseIdentifier: String(describing: TimelineCell.self),
                          listItems: [],
                          cellConfigurationHandler: { (cell, item, indexPath) in
            cell.delegate = self
            cell.identificationId = indexPath.row
            cell.content = item
        })
    }()
    
    var ui: GoalUI!
    
    var routing: GoalRouting!
    
    var presenter: GoalPresenter! {
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
    
    func inject(ui: GoalUI,
                presenter: GoalPresenter,
                routing: GoalRouting,
                disposeBag: DisposeBag) {
        self.ui = ui
        self.presenter = presenter
        self.routing = routing
        self.disposeBag = disposeBag
        
        self.presenter.fetch(from: .sample, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ui.setup()
    }
}

extension GoalViewController: GoalPresenterView {
    
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
            self.createLikedRef(documentRef: .likeUserRef(goalDocument: self.dataSource.listItems[didSelectIndex].documentId))
            self.presenter.update(to: .goalUpdateRef(author_token: self.dataSource.listItems[didSelectIndex].authorToken,
                                                     goalDocument: self.dataSource.listItems[didSelectIndex].documentId),
                                                     value: ["like_count": FieldValue.increment(1.0)])
        case true:
            self.deleteLikedRef(documentRef: .likeUserRef(goalDocument: self.dataSource.listItems[didSelectIndex].documentId))
            self.presenter.update(to: .goalUpdateRef(author_token: self.dataSource.listItems[didSelectIndex].authorToken,
                                                     goalDocument: self.dataSource.listItems[didSelectIndex].documentId),
                                                     value: ["like_count": FieldValue.increment(-1.0)])
        }
    }
}

extension GoalViewController: CellTapDelegate {
    
    func tappedLikeBtn(index: Int) {
        presenter.get(documentRef: .likeUserRef(goalDocument: dataSource.listItems[index].documentId))
        didSelectIndex = index
    }
    
    func createLikedRef(documentRef: FirebaseDocumentRef) {
        documentRef.destination.setData([:])
    }
    
    func deleteLikedRef(documentRef: FirebaseDocumentRef) {
        documentRef.destination.delete()
    }
}
