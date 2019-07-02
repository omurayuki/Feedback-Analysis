import Foundation
import UIKit
import RxSwift
import RxCocoa
import FirebaseFirestore

class DetailViewController: UIViewController {
    
    typealias DetailDataSource = TableViewDataSource<TimelineCell, Timeline>
    typealias CommentDataStore = TableViewDataSource<CommentCell, Comment>
    
    private(set) var detailDataSource: DetailDataSource = {
        return DetailDataSource(cellReuseIdentifier: String(describing: TimelineCell.self),
                                listItems: [],
                                cellConfigurationHandler: { (cell, item, _) in
                                    cell.content = item
        })
    }()
    
    private(set) var commentDataSource: CommentDataStore = {
        return CommentDataStore(cellReuseIdentifier: String(describing: CommentCell.self),
                                listItems: [],
                                cellConfigurationHandler: { (cell, item, _) in
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
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ui.setup()
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
                    ui.isHiddenSubmitBtn(false)
                    keyboardHeight = keyboardHeight - view.safeAreaInsets.bottom + ui.submitBtn.frame.height + 8
                } else {
                    ui.isHiddenSubmitBtn(true)
                }
            }
            ui.textViewBottomConstraint.constant = -keyboardHeight - 8
            view.layoutIfNeeded()
        }
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
        let comment = CommentPost(authorToken: data.authToken,
                              comment: ui.commentField.text,
                              likeCount: 0, repliedCount: 0,
                              createdAt: FieldValue.serverTimestamp(),
                              updatedAt: FieldValue.serverTimestamp())
        presenter.getDocumentId(completion: { [unowned self] documentId in
            self.presenter.post(to: .commentRef(goalDocument: documentId), comment: comment)
        })
    }
    
    func didPostSuccess() {
        ui.clearCommentField()
        presenter.getDocumentId(completion: { [unowned self] documentId in
            self.presenter.get(from: .commentRef(goalDocument: documentId))
        })
    }
    
    func didFetchComments(comments: [Comment]) {
        commentDataSource.listItems = []
        commentDataSource.listItems += comments
        ui.commentTable.reloadData()
    }
}
