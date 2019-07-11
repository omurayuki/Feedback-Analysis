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
                                isSkelton: true,
                                cellConfigurationHandler: { (cell, item, indexPath) in
            cell.delegate = self
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
            ui.editBtn.rx.tap.asDriver()
                .drive(onNext: { [unowned self] _ in
                    self.routing.moveGoalPostEditPage(with: self.detailDataSource.listItems[0])
                }).disposed(by: disposeBag)
            
            ui.submitBtn.rx.tap.asDriver()
                .drive(onNext: { [unowned self] _ in
                    self.presenter.fetch()
                }).disposed(by: disposeBag)
            
            ui.commentField.rx.text.asDriver()
                .drive(onNext: { [unowned self] text in
                    guard let text = text else { return }
                    self.ui.commentFieldTextCount.text = "70/\(String(describing: text.count))"
                    self.ui.commentFieldTextCount.textColor = text.count > 70 ? .red : .appSubColor
                }).disposed(by: disposeBag)
            
            ui.viewTapGesture.rx.event
                .bind { [unowned self] _ in
                    self.view.endEditing(true)
                }.disposed(by: disposeBag)
            
            NotificationCenter.default.rx
                .notification(UIResponder.keyboardWillShowNotification, object: nil)
                .subscribe(onNext: { [unowned self] notification in
                    self.keyboardWillChangeFrame(notification)
                }).disposed(by: disposeBag)
            
            NotificationCenter.default.rx
                .notification(UIResponder.keyboardWillHideNotification, object: nil)
                .subscribe(onNext: { [unowned self] notification in
                    self.keyboardWillChangeFrame(notification)
                }).disposed(by: disposeBag)
            
            presenter.isLoading
                .subscribe(onNext: { [unowned self] isLoading in
                    self.view.endEditing(true)
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        routing.popToViewController()
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
            self.validatePostedField(postedValue: self.ui.commentField.text, account: { value in
                self.presenter.post(to: .commentRef(goalDocument: documentId),
                                    comment: self.createComment(token: data.authToken,
                                                                goalDocumentId: documentId,
                                                                comment: value))
            })
        })
    }
    
    func didPostSuccess() {
        ui.clearCommentField()
        presenter.getDocumentId(completion: { [unowned self] documentId in
            self.presenter.get(from: .commentRef(goalDocument: documentId))
        })
    }
    
    func didFetchComments(comments: [Comment]) {
        mappingDataToDataSource(comments: comments)
        ui.updateCommentCount(commentDataSource.listItems.count)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            self.presenter.view.updateLoading(false)
            self.commentDataSource.listItems.isEmpty ? self.updateCommentCellIfEmpty() : self.ui.commentTable.reloadData()
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
}

extension DetailViewController {
    
    func recieve(data timeline: Timeline, height: CGFloat) {
        presenter.set(document: timeline.documentId) {
            self.isEnableEdit(timeline.achievedFlag)
            self.ui.determineHeight(height: height)
            self.detailDataSource.listItems.append(timeline)
            self.ui.detail.reloadData()
            self.presenter.getDocumentId(completion: { [unowned self] documentId in
                self.presenter.get(from: .commentRef(goalDocument: documentId))
            })
        }
    }
    
    func isEnableEdit(_ bool: Bool) {
        ui.editBtn.isEnabled = !bool
    }
    
    func keyboardWillChangeFrame(_ notification: Notification) {
        if let endFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            var keyboardHeight = UIScreen.main.bounds.height - endFrame.origin.y
            if #available(iOS 11, *) {
                if keyboardHeight > 0 {
                    view.addGestureRecognizer(ui.viewTapGesture)
                    ui.isHiddenSubmitBtn(false)
                    ui.isHiddenTextCount(false)
                    keyboardHeight = keyboardHeight - view.safeAreaInsets.bottom + ui.submitBtn.frame.height + 8
                } else {
                    view.removeGestureRecognizer(ui.viewTapGesture)
                    ui.isHiddenSubmitBtn(true)
                    ui.isHiddenTextCount(true)
                }
            }
            ui.textViewBottomConstraint.constant = -keyboardHeight - 8
            view.layoutIfNeeded()
        }
    }
    
    func mappingDataToDataSource(comments: [Comment]) {
        commentDataSource.listItems = []
        commentDataSource.listItems += comments
    }
    
    func updateCommentCellIfEmpty() {
        for i in 0 ..< 10 {
            let indexPath = NSIndexPath(row: i, section: 0)
            guard let cell = ui.commentTable.cellForRow(at: indexPath as IndexPath) as? CommentCell else { return }
            cell.hideSkelton(cell.userPhoto, cell.userName)
            cell.removeFromSuperview()
        }
    }
    
    func updateLikeCount(index: Int, count: Int) {
        commentDataSource.listItems[index].likeCount += count
        ui.commentTable.reloadData()
    }
    
    func createComment(token: String, goalDocumentId: String, comment: String) -> CommentPost {
        return CommentPost(authorToken: token,
                           goalDocumentId: goalDocumentId,
                           comment: comment,
                           likeCount: 0, repliedCount: 0,
                           createdAt: FieldValue.serverTimestamp(),
                           updatedAt: FieldValue.serverTimestamp())
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
