import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol ReplyPresenter {
    var view: ReplyPresenterView! { get set }
    var isLoading: BehaviorRelay<Bool> { get }
    
    func fetch()
    func post(to documentRef: FirebaseDocumentRef, reply: ReplyPost)
    func get(from queryRef: FirebaseQueryRef)
    func set(comment id: String, completion: @escaping () -> Void)
    func getDocumentIds(completion: @escaping (_ documentId: String, _ commentId: String) -> Void)
}

protocol ReplyPresenterView: class {
    var disposeBag: DisposeBag! { get }
    
    func inject(ui: ReplyUI,
                presenter: ReplyPresenter,
                routing: ReplyRouting,
                disposeBag: DisposeBag)
    func didChangeTextHeight()
    func didFetchUser(data: Account)
    func didPostSuccess()
    func didFetchReplies(replies: [Reply])
    func didSelect(tableView: UITableView, indexPath: IndexPath)
    func showError(message: String)
    func updateLoading(_ isLoading: Bool)
}
