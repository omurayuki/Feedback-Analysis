import Foundation
import UIKit
import RxSwift
import RxCocoa
import FirebaseFirestore

class GoalsBaseViewController: UIViewController {
    
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
    
    //// timelineでqueryの値を変更することで、エンドポイントを変更
    var queryRef: FirebaseQueryRef = .publicGoalRef
    
    var ui: PublicTimelineContentUI!
    
    var routing: PublicTimelineContentRouting!
    
    var presenter: PublicTimelineContentPresenter! {
        didSet {
            presenter.view = self
        }
    }
    
    var disposeBag: DisposeBag! {
        didSet {
            ui.refControl.rx.controlEvent(.valueChanged)
                .subscribe(onNext: { [unowned self] _ in
                    self.presenter.fetch(from: self.queryRef, loading: false, completion: nil)
                }).disposed(by: disposeBag)
            
            presenter.isLoading
                .subscribe(onNext: { [unowned self] isLoading in
                    self.view.endEditing(true)
                    self.setIndicator(show: isLoading)
                }).disposed(by: disposeBag)
        }
    }
    
    func inject(ui: PublicTimelineContentUI,
                presenter: PublicTimelineContentPresenter,
                routing: PublicTimelineContentRouting,
                disposeBag: DisposeBag) {
        self.ui = ui
        self.presenter = presenter
        self.routing = routing
        self.disposeBag = disposeBag
        
        self.presenter.fetch(from: queryRef, loading: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //// DetailVCから戻ってきた際にもう一度タイムライン情報をfetchしてこなければ、authorTokenを配列でuserDefaultsに保存できない
        ui.timeline.isUserInteractionEnabled = false
        presenter.fetch(from: queryRef, loading: presenter.isFirstLoading) {
            self.presenter.isFirstLoading = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ui.setup()
    }
}

extension GoalsBaseViewController: PublicTimelineContentPresenterView {
    
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

extension GoalsBaseViewController {
    
    func updateLikeCount(index: Int, count: Int) {
        dataSource.listItems[index].likeCount += count
        ui.timeline.reloadData()
    }
}

extension GoalsBaseViewController: CellTapDelegate {
    
    func tappedLikeBtn(index: Int) {
        self.presenter.getAuthorToken(completion: { [unowned self] token in
            self.presenter.get(documentRef: .likeUserRef(goalDocument: self.dataSource.listItems[index].documentId,
                                                         authorToken: token))
            self.presenter.setSelected(index: index)
        })
    }
}

extension GoalsBaseViewController: UserPhotoTapDelegate {
    
    func tappedUserPhoto(index: Int) {
        presenter.getAuthorToken { [unowned self] subjectToken in
            self.presenter.getAuthorToken(index) { [unowned self] objectToken in
                objectToken == subjectToken ? (UIDevice.vibrate()) : (self.routing.showOtherPersonPage(with: objectToken))
            }
        }
    }
}
