import Foundation
import UIKit
import RxSwift
import RxCocoa
import FirebaseFirestore

class ReplyViewController: UIViewController, HalfModalPresentable {
    
    typealias CommentDataSource = TableViewDataSource<CommentCell, Comment>
    typealias ReplyDataStore = TableViewDataSource<ReplyCell, Reply>
    
    private(set) lazy var commentDataSource: CommentDataSource = {
        return CommentDataSource(cellReuseIdentifier: String(describing: CommentCell.self),
                                listItems: [],
                                isSkelton: false,
                                cellConfigurationHandler: { (cell, item, _) in
            cell.content = item
        })
    }()
    
    private(set) lazy var replyDataSource: ReplyDataStore = {
        return ReplyDataStore(cellReuseIdentifier: String(describing: ReplyCell.self),
                                listItems: [],
                                isSkelton: false,
                                cellConfigurationHandler: { (cell, item, _) in
            cell.content = item
        })
    }()
    
    var ui: ReplyUI!
    
    var routing: ReplyRouting!
    
    var presenter: ReplyPresenter! {
        didSet {
            presenter.view = self
        }
    }
    
    var disposeBag: DisposeBag! {
        didSet {
            ui.expandBtn.rx.tap.asDriver()
                .drive(onNext: { [unowned self] _ in
                    self.maximizeToFullScreen()
                    self.ui.replyField.becomeFirstResponder()
                }).disposed(by: disposeBag)
            
            ui.cancelBtn.rx.tap.asDriver()
                .drive(onNext: { [unowned self] _ in
                    guard let delegate
                        = self.navigationController?.transitioningDelegate as? HalfModalTransitioningDelegate else { return }
                    delegate.interactiveDismiss = false
                    self.routing.dismiss()
                }).disposed(by: disposeBag)
            
            ui.replyField.rx.didBeginEditing.asDriver()
                .drive(onNext: { [unowned self] _ in
                    self.maximizeToFullScreen()
                }).disposed(by: disposeBag)
            
            ui.submitBtn.rx.tap.asDriver()
                .drive(onNext: { [unowned self] _ in
                    self.presenter.fetch()
                }).disposed(by: disposeBag)
            
            ui.replyField.rx.text.asDriver()
                .drive(onNext: { [unowned self] text in
                    guard let text = text else { return }
                    self.ui.replyFieldTextCount.text = "70/\(String(describing: text.count))"
                    self.ui.replyFieldTextCount.textColor = text.count > 70 ? .red : .appSubColor
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
    
    func inject(ui: ReplyUI,
                presenter: ReplyPresenter,
                routing: ReplyRouting,
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

extension ReplyViewController: ReplyPresenterView {
    
    func updateLoading(_ isLoading: Bool) {
        presenter.isLoading.accept(isLoading)
    }
    
    func didChangeTextHeight() {
        view.layoutIfNeeded()
    }
    
    func didFetchUser(data: Account) {
        presenter.getDocumentIds(completion: { [unowned self] _, commentId in
            self.validatePostedField(postedValue: self.ui.replyField.text, account: { value in
                self.presenter.post(to: .replyRef(commentDocument: commentId),
                                    reply: self.createReply(token: data.authToken, reply: value))
            })
        })
    }
    
    func didPostSuccess() {
        ui.clearReplyField()
        presenter.getDocumentIds(completion: { [unowned self] _, commentId in
            self.presenter.get(from: .replyRef(commentDocument: commentId))
        })
    }
    
    func didFetchReplies(replies: [Reply]) {
        mappingDataToDataSource(replies: replies)
        ui.updateReplyCount(replyDataSource.listItems.count)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            self.presenter.view.updateLoading(false)
            self.ui.replyTable.reloadData()
        }
    }
    
    func didSelect(tableView: UITableView, indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func createReply(token: String, reply: String) -> ReplyPost {
        return ReplyPost(authorToken: token,
                         reply: reply,
                         createdAt: FieldValue.serverTimestamp(),
                         updatedAt: FieldValue.serverTimestamp())
    }
}

extension ReplyViewController {
    
    func recieve(data comment: Comment, height: CGFloat) {
        presenter.set(comment: comment.documentId) {
            self.ui.determineHeight(height: height)
            self.commentDataSource.listItems.append(comment)
            self.ui.comment.reloadData()
            self.presenter.getDocumentIds(completion: { [unowned self] _, commentId  in
                self.presenter.get(from: .replyRef(commentDocument: commentId))
            })
        }
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
    
    func mappingDataToDataSource(replies: [Reply]) {
        replyDataSource.listItems = []
        replyDataSource.listItems += replies
    }
}
