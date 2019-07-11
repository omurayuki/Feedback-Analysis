import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol GoalPostPresenter: Presenter {
    var view: GoalPostPresenterView! { get set }
    var isLoading: BehaviorRelay<Bool> { get }
    
    func post(to documentRef: FirebaseDocumentRef, fields: GoalPost)
    func getAuthorToken(completion: @escaping (String) -> Void)
}

protocol GoalPostPresenterView: class {
    var disposeBag: DisposeBag! { get }
    
    func inject(ui: GoalPostUI,
                presenter: GoalPostPresenter,
                routing: GoalPostRouting,
                disposeBag: DisposeBag)
    func didPostSuccess()
    func didSelectSegment(with index: Int)
    func showError(message: String)
    func updateLoading(_ isLoading: Bool)
}
