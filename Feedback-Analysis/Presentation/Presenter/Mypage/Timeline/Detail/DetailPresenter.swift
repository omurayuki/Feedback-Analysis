import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol DetailPresenter {
    var view: DetailPresenterView! { get set }
    var isLoading: BehaviorRelay<Bool> { get }
    
    func fetch()
    func post(to documentRef: FirebaseDocumentRef, comment: CommentPost)
    func get(from queryRef: FirebaseQueryRef)
    func set(document id: String, completion: @escaping () -> Void)
    func getDocumentId(completion: @escaping (String) -> Void)
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
    func didFetchComments(comments: [Comment])
    func showError(message: String)
    func updateLoading(_ isLoading: Bool)
}
