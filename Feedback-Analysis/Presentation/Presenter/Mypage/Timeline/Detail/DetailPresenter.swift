import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol DetailPresenter {
    var view: DetailPresenterView! { get set }
    var isLoading: BehaviorRelay<Bool> { get }
    var keyboardNotifier: KeyboardNotifier! { get }
    
    func fetch()
    func update(to documentRef: FirebaseDocumentRef, value: [String: Any])
    func create(documentRef: FirebaseDocumentRef, value: [String: Any])
    func delete(documentRef: FirebaseDocumentRef)
    func post(to documentRef: FirebaseDocumentRef, comment: CommentPost)
    func get(from queryRef: FirebaseQueryRef)
    func set(document id: String, completion: @escaping () -> Void)
    func set(otherPersonAuthorToken token: String)
    func getDocumentId(completion: @escaping (String) -> Void)
    func get(documentRef: FirebaseDocumentRef)
    func getOtherPersonAuthorToken(completion: @escaping (String) -> Void)
    func setSelected(index: Int)
    func getSelected(completion: @escaping (Int) -> Void)
    func getAuthorToken(completion: @escaping (String) -> Void)
    func setAuthorTokens(_ values: [String])
    func getAuthorToken(_ index: Int, completion: @escaping (String) -> Void)
}

protocol DetailPresenterView: class {
    var disposeBag: DisposeBag! { get }
    
    func inject(ui: DetailUI,
                presenter: DetailPresenter,
                routing: DetailRouting,
                disposeBag: DisposeBag)
    func didChangeTextHeight()
    func didFetchUser(data: Account)
    func didPostSuccess()
    func didCheckIfYouLiked(_ bool: Bool)
    func didCreateLikeRef()
    func didDeleteLikeRef()
    func didFetchComments(comments: [Comment])
    func didSelect(tableView: UITableView, indexPath: IndexPath)
    func keyboardPresent(_ height: CGFloat)
    func keyboardDismiss(_ height: CGFloat)
    func showError(message: String)
    func updateLoading(_ isLoading: Bool)
}
