import Foundation
import UIKit
import RxSwift
import RxCocoa
import FirebaseFirestore

class PublicGoalViewController: UIViewController {
    
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
    
    var routing: PublicGoalRouting!
    
    var presenter: PublicGoalPresenter! {
        didSet {
            presenter.view = self
        }
    }
    
    var disposeBag: DisposeBag! {
        didSet {
            ui.refControl.rx.controlEvent(.valueChanged)
                .subscribe(onNext: { _ in
                    self.presenter.fetch(from: .publicGoalRef, loading: false, completion: nil)
                }).disposed(by: disposeBag)
            
            presenter.isLoading
                .subscribe(onNext: { [unowned self] isLoading in
                    self.view.endEditing(true)
                    self.setIndicator(show: isLoading)
                }).disposed(by: disposeBag)
        }
    }
    
    func inject(ui: PublicTimelineContentUI,
                presenter: PublicGoalPresenter,
                routing: PublicGoalRouting,
                disposeBag: DisposeBag) {
        self.ui = ui
        self.presenter = presenter
        self.routing = routing
        self.disposeBag = disposeBag
        
        self.presenter.fetch(from: .publicGoalRef, loading: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ui.setup()
    }
}

extension PublicGoalViewController: PublicGoalPresenterView {
    
    func updateLoading(_ isLoading: Bool) {
        presenter.isLoading.accept(isLoading)
    }
    
    func didFetchGoalData(timeline: [Timeline]) {
        dataSource.listItems = []
        dataSource.listItems += timeline
        presenter.setAuthorTokens(timeline.compactMap { $0.authorToken })
        ui.timeline.reloadData()
        ui.refControl.endRefreshing()
    }
    
    func didSelect(indexPath: IndexPath, tableView: UITableView) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let height = tableView.cellForRow(at: indexPath)?.contentView.frame.height else { return }
        routing.showDetail(with: dataSource.listItems[indexPath.row], height: height + 2)
        self.presenter.fetch(from: .publicGoalRef, loading: false, completion: nil)
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

extension PublicGoalViewController {
    
    func updateLikeCount(index: Int, count: Int) {
        dataSource.listItems[index].likeCount += count
        ui.timeline.reloadData()
    }
}

extension PublicGoalViewController: CellTapDelegate {
    
    func tappedLikeBtn(index: Int) {
        self.presenter.getAuthorToken(completion: { [unowned self] token in
            self.presenter.get(documentRef: .likeUserRef(goalDocument: self.dataSource.listItems[index].documentId,
                                                    authorToken: token))
            self.presenter.setSelected(index: index)
        })
    }
}

extension PublicGoalViewController: UserPhotoTapDelegate {
    
    func tappedUserPhoto(index: Int) {
        presenter.getAuthorToken(index) { [unowned self] token in
            self.routing.showOtherPersonPage(with: token)
            // 時画面に遷移するときに、初期化タイミングでデータをfetch
            // 時画面でskeltonさせて表示
            // UI作成
            // detailからも遷移できるようにUI調整
            // フォロー機能作成
            // フォロワー機能作成
            // フォローしている人の目標閲覧作成
        }
    }
}
