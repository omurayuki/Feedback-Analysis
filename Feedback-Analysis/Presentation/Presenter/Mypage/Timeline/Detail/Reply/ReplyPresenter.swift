import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol ReplyPresenter {
    var view: ReplyPresenterView! { get set }
    var isLoading: BehaviorRelay<Bool> { get }
    var keyboardNotifier: KeyboardNotifier! { get }
    
    func fetch()
    func post(to documentRef: FirebaseDocumentRef, reply: ReplyPost)
    func get(from queryRef: FirebaseQueryRef, isLoading: Bool)
    func set(comment id: String, completion: @escaping () -> Void)
    func set(otherPersonAuthorToken token: String)
    func getDocumentIds(completion: @escaping (_ documentId: String, _ commentId: String) -> Void)
    func getOtherPersonAuthorToken(completion: @escaping (String) -> Void)
    func setAuthorTokens(_ values: [String])
    func getAuthorToken(completion: @escaping (String) -> Void)
    func getAuthorToken(_ index: Int, completion: @escaping (String) -> Void)
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
    func keyboardPresent(_ height: CGFloat)
    func keyboardDismiss(_ height: CGFloat)
    func showError(message: String)
    func updateLoading(_ isLoading: Bool)
}
