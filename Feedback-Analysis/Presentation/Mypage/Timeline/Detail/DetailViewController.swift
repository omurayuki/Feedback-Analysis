import Foundation
import UIKit
import RxSwift
import RxCocoa
import FirebaseFirestore

class DetailViewController: UIViewController {
    
    typealias DetailDataSource = TableViewDataSource<TimelineCell, Timeline>
    typealias CommentDataStore = TableViewDataSource<CommentCell, Comment>
    
    private(set) lazy var detailDataSource: DetailDataSource = {
        return DetailDataSource(cellReuseIdentifier: String(describing: TimelineCell.self),
                                listItems: [],
                                isSkelton: false,
                                cellConfigurationHandler: { (cell, item, _) in
            cell.content = item
        })
    }()
    
    private(set) lazy var commentDataSource: CommentDataStore = {
        return CommentDataStore(cellReuseIdentifier: String(describing: CommentCell.self),
                                listItems: [],
                                isSkelton: false,
                                cellConfigurationHandler: { (cell, item, indexPath) in
            cell.cellTapDelegate = self
            cell.userPhotoTapDelegate = self
            cell.identificationId = indexPath.row
            cell.content = item
        })
    }()
    
    var ui: DetailUI!
    
    var routing: DetailRouting!
    
    var presenter: DetailPresenter! {
        didSet {
            presenter.view = self
        }
    }
    
    var disposeBag: DisposeBag! {
        didSet {
            ui.refControl.rx.controlEvent(.valueChanged)
                .subscribe(onNext: { [unowned self] _ in
                    self.getComments(isLoading: false)
                }).disposed(by: disposeBag)
            
            ui.detailUserPhotoGesture.rx.event.asDriver()
                .drive(onNext: { [unowned self] _ in
                    self.presenter.getOtherPersonAuthorToken(completion: { [unowned self] objectToken in
                        self.presenter.getAuthorToken(completion: { [unowned self] subjectToken in
                            objectToken == subjectToken ? (self.view.shake(duration: 1)) : self.routing.showOtherPersonPage(with: objectToken)
                        })
                    })
                }).disposed(by: disposeBag)
            
            ui.editBtn.rx.tap.asDriver()
                .drive(onNext: { [unowned self] _ in
                    self.routing.moveGoalPostEditPage(with: self.detailDataSource.listItems[0])
                }).disposed(by: disposeBag)
            
            ui.submitBtn.rx.tap.asDriver()
                .drive(onNext: { [unowned self] _ in
                    self.presenter.fetch()
                }).disposed(by: disposeBag)
            
            ui.commentField.rx.didBeginEditing.asDriver()
                .drive(onNext: { [unowned self] _ in
                    self.view.layoutIfNeeded()
                }).disposed(by: disposeBag)
            
            ui.commentField.rx.text.asDriver()
                .drive(onNext: { [unowned self] text in
                    guard let text = text else { return }
                    self.ui.commentFieldTextCount.text = "70/\(String(describing: text.count))"
                    self.ui.commentFieldTextCount.textColor = text.count > 70 ? .red : .appSubColor
                }).disposed(by: disposeBag)
            
            ui.viewTapGesture.rx.event
                .bind { [unowned self] _ in
                    self.ui.commentField.resignFirstResponder()
                }.disposed(by: disposeBag)
            
            presenter.isLoading
                .subscribe(onNext: { [unowned self] isLoading in
                    self.setIndicator(show: isLoading)
                }).disposed(by: disposeBag)
        }
    }
    
    func inject(ui: DetailUI,
                presenter: DetailPresenter,
                routing: DetailRouting,
                disposeBag: DisposeBag) {
        self.ui = ui
        self.presenter = presenter
        self.routing = routing
        self.disposeBag = disposeBag
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        ui.setup()
    }
}

extension DetailViewController: DetailPresenterView {
    
    func updateLoading(_ isLoading: Bool) {
        presenter.isLoading.accept(isLoading)
    }
    
    func didChangeTextHeight() {
        view.layoutIfNeeded()
    }
    
    func didFetchUser(data: Account) {
        presenter.getDocumentId(completion: { [unowned self] documentId in
            self.validatePostedField(postedValue: self.ui.commentField.text, account: { [unowned self] value in
                #warning("後々UX向上のためpostは裏側で行い表では普通にuser情報をマッピング")
                self.presenter.post(to: .commentRef(goalDocument: documentId),
                                    comment: CommentPost.createComment(token: data.authToken,
                                                                goalDocumentId: documentId,
                                                                comment: value))
            })
        })
    }
    
    func didPostSuccess() {
        ui.clearCommentField()
        getComments(isLoading: true)
    }
    
    func didFetchComments(comments: [Comment]) {
        mappingDataToDataSource(comments: comments)
        ui.updateCommentCount(commentDataSource.listItems.count)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            self.presenter.view.updateLoading(false)
            self.commentDataSource.listItems.isEmpty ? () : self.ui.commentTable.reloadData()
            self.ui.refControl.endRefreshing()
        }
    }
    
    func didSelect(tableView: UITableView, indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let height = tableView.cellForRow(at: indexPath)?.contentView.frame.height else { return }
        routing.showReplyPage(with: commentDataSource.listItems[indexPath.row], height: height + 2)
    }
    
    func didCheckIfYouLiked(_ bool: Bool) {
        switch bool {
        case false:
            presenter.getSelected { [unowned self] index in
                self.updateLikeCount(index: index, count: 1)
                self.presenter.getAuthorToken(completion: { [unowned self] token in
                    self.presenter.create(documentRef: .likeCommentRef(commentDocument: self.commentDataSource.listItems[index].documentId,
                                                                       authorToken: token), value: [:])
                })
            }
        case true:
            presenter.getSelected { [unowned self] index in
                self.updateLikeCount(index: index, count: -1)
                self.presenter.getAuthorToken(completion: { [unowned self] token in
                    self.presenter.delete(documentRef: .likeCommentRef(commentDocument: self.commentDataSource.listItems[index].documentId,
                                                                       authorToken: token))
                })
            }
        }
    }
    
    func didCreateLikeRef() {
        presenter.getSelected { [unowned self] index in
            self.presenter.update(to: .commentUpdateRef(goalDocument: self.commentDataSource.listItems[index].goalDocumentId,
                                                     commentDocument: self.commentDataSource.listItems[index].documentId),
                                  value: ["like_count": FieldValue.increment(1.0)])
        }
    }
    
    func didDeleteLikeRef() {
        presenter.getSelected { [unowned self] index in
            self.presenter.update(to: .commentUpdateRef(goalDocument: self.commentDataSource.listItems[index].goalDocumentId,
                                                        commentDocument: self.commentDataSource.listItems[index].documentId),
                                  value: ["like_count": FieldValue.increment(-1.0)])
        }
    }
    
    func keyboardPresent(_ height: CGFloat) {
        ui.changeViewWithKeyboardY(false, height: height - view.safeAreaInsets.bottom + ui.submitBtn.frame.height + 8)
    }
    
    func keyboardDismiss(_ height: CGFloat) {
        ui.changeViewWithKeyboardY(true, height: height)
    }
}

extension DetailViewController {
    
    func recieve(data timeline: Timeline, height: CGFloat) {
        presenter.set(otherPersonAuthorToken: timeline.authorToken)
        presenter.set(document: timeline.documentId) {
            self.isEnableEdit(timeline.achievedFlag)
            self.ui.determineHeight(height: height)
            self.detailDataSource.listItems.append(timeline)
            self.ui.detail.reloadData()
            self.getComments(isLoading: true)
        }
    }
    
    func isEnableEdit(_ bool: Bool) {
        ui.editBtn.isEnabled = !bool
    }
    
    func mappingDataToDataSource(comments: [Comment]) {
        commentDataSource.listItems = []
        commentDataSource.listItems += comments
        presenter.setAuthorTokens(comments.compactMap { $0.authorToken })
    }
    
    func updateLikeCount(index: Int, count: Int) {
        commentDataSource.listItems[index].likeCount += count
        ui.commentTable.reloadData()
    }
    
    func getComments(isLoading: Bool) {
        presenter.getDocumentId(completion: { [unowned self] documentId in
            self.presenter.get(from: .commentRef(goalDocument: documentId), isLoading: isLoading)
        })
    }
}

extension DetailViewController: CellTapDelegate {
    
    func tappedLikeBtn(index: Int) {
        self.presenter.getAuthorToken(completion: { [unowned self] token in
            self.presenter.get(documentRef: .likeCommentRef(commentDocument: self.commentDataSource.listItems[index].documentId,
                                                            authorToken: token))
            self.presenter.setSelected(index: index)
        })
    }
}

extension DetailViewController: UserPhotoTapDelegate {
    
    func tappedUserPhoto(index: Int) {
        presenter.getAuthorToken { [unowned self] subjectToken in
            self.presenter.getAuthorToken(index) { [unowned self] objectToken in
                subjectToken == objectToken ? (self.view.shake(duration: 1)) : (self.routing.showOtherPersonPage(with: objectToken))
            }
        }
    }
}
