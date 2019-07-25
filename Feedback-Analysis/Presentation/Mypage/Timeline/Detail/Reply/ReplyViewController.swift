import Foundation
import UIKit
import RxSwift
import RxCocoa
import FirebaseFirestore

class ReplyViewController: UIViewController {
    
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
                                cellConfigurationHandler: { (cell, item, indexPath) in
            cell.userPhotoTapDelegate = self
            cell.identificationId = indexPath.row
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
            ui.replyUserPhotoGesture.rx.event.asDriver()
                .drive(onNext: { [unowned self] _ in
                    self.presenter.getOtherPersonAuthorToken(completion: { [unowned self] token in
                        self.routing.showOtherPersonPage(with: token)
                        self.maximizeToFullScreen()
                    })
                }).disposed(by: disposeBag)
            
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
                    self.view.layoutIfNeeded()
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
                                    reply: ReplyPost.createReply(token: data.authToken, reply: value))
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
        }
    }
    
    func didSelect(tableView: UITableView, indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func keyboardPresent(_ height: CGFloat) {
        ui.changeViewWithKeyboardY(false, height: height - view.safeAreaInsets.bottom + ui.submitBtn.frame.height + 8)
    }
    
    func keyboardDismiss(_ height: CGFloat) {
        ui.changeViewWithKeyboardY(true, height: height)
    }
}

extension ReplyViewController {
    
    func recieve(data comment: Comment, height: CGFloat) {
        presenter.set(otherPersonAuthorToken: comment.authorToken)
        presenter.set(comment: comment.documentId) {
            self.ui.determineHeight(height: height)
            self.commentDataSource.listItems.append(comment)
            self.ui.comment.reloadData()
            self.presenter.getDocumentIds(completion: { [unowned self] _, commentId  in
                self.presenter.get(from: .replyRef(commentDocument: commentId))
            })
        }
    }
    
    func mappingDataToDataSource(replies: [Reply]) {
        replyDataSource.listItems = []
        replyDataSource.listItems += replies
        presenter.setAuthorTokens(replies.compactMap { $0.authorToken })
    }
}

extension ReplyViewController: UserPhotoTapDelegate {
    
    func tappedUserPhoto(index: Int) {
        presenter.getAuthorToken(index) { [unowned self] token in
            self.routing.showOtherPersonPage(with: token)
            self.maximizeToFullScreen()
        }
    }
}

extension ReplyViewController: HalfModalPresentable {}
