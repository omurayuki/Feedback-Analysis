import Foundation
import UIKit
import RxSwift
import RxCocoa
import FirebaseFirestore

class PublicCompleteViewController: UIViewController {
    
    typealias DataSource = TableViewDataSource<TimelineCell, Timeline>
    
    private(set) lazy var dataSource: DataSource = {
        return DataSource(cellReuseIdentifier: String(describing: TimelineCell.self),
                          listItems: [],
                          isSkelton: false,
                          cellConfigurationHandler: { (cell, item, indexPath) in
            cell.cellTapDelegate = self
            cell.userPhotoTapDelegate = self
            cell.identificationId = indexPath.row
            cell.content = item
        })
    }()
    
    var ui: PublicTimelineContentUI!
    
    var routing: PublicCompleteRouting!
    
    var presenter: PublicCompletePresenter! {
        didSet {
            presenter.view = self
        }
    }
    
    var disposeBag: DisposeBag! {
        didSet {
            ui.refControl.rx.controlEvent(.valueChanged)
                .subscribe(onNext: { _ in
                    self.presenter.fetch(from: .publicCompleteRef, loading: false, completion: nil)
                }).disposed(by: disposeBag)
            
            presenter.isLoading
                .subscribe(onNext: { [unowned self] isLoading in
                    self.view.endEditing(true)
                    self.setIndicator(show: isLoading)
                }).disposed(by: disposeBag)
        }
    }
    
    func inject(ui: PublicTimelineContentUI,
                presenter: PublicCompletePresenter,
                routing: PublicCompleteRouting,
                disposeBag: DisposeBag) {
        self.ui = ui
        self.presenter = presenter
        self.routing = routing
        self.disposeBag = disposeBag
        
        self.presenter.fetch(from: .publicCompleteRef, loading: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //// DetailVCから戻ってきた際にもう一度タイムライン情報をfetchしてこなければ、authorTokenを配列でuserDefaultsに保存できない
        ui.timeline.isUserInteractionEnabled = false
        presenter.fetch(from: .publicCompleteRef, loading: presenter.isFiestLoading) {
            self.presenter.isFiestLoading = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ui.setup()
    }
}

extension PublicCompleteViewController: PublicCompletePresenterView {
    
    func updateLoading(_ isLoading: Bool) {
        presenter.isLoading.accept(isLoading)
    }
    
    func didFetchGoalData(timeline: [Timeline]) {
        dataSource.listItems = []
        dataSource.listItems += timeline
        presenter.setAuthorTokens(timeline.compactMap { $0.authorToken })
        ui.timeline.isUserInteractionEnabled = true
        ui.timeline.reloadData()
        ui.refControl.endRefreshing()
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

extension PublicCompleteViewController {
    
    func updateLikeCount(index: Int, count: Int) {
        dataSource.listItems[index].likeCount += count
        ui.timeline.reloadData()
    }
}

extension PublicCompleteViewController: CellTapDelegate {
    
    func tappedLikeBtn(index: Int) {
        self.presenter.getAuthorToken(completion: { [unowned self] token in
            self.presenter.get(documentRef: .likeUserRef(goalDocument: self.dataSource.listItems[index].documentId,
                                                         authorToken: token))
            self.presenter.setSelected(index: index)
        })
    }
}

extension PublicCompleteViewController: UserPhotoTapDelegate {
    
    func tappedUserPhoto(index: Int) {
        presenter.getAuthorToken { [unowned self] subjectToken in
            self.presenter.getAuthorToken(index) { [unowned self] objectToken in
                objectToken == subjectToken ? () : (self.routing.showOtherPersonPage(with: objectToken))
            }
        }
    }
}
