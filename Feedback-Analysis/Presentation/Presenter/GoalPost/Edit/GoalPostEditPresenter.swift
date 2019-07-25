import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol GoalPostEditPresenter: Presenter {
    var startPoint: CGPoint? { get set }
    var genres: [String] { get set }
    var view: GoalPostEditPresenterView! { get set }
    var isLoading: BehaviorRelay<Bool> { get }
    
    func update(to documentRef: FirebaseDocumentRef, fields: GoalPost)
    func getAuthorToken(completion: @escaping (String) -> Void)
    func getGoalDocumentId(completion: @escaping (String) -> Void)
    func setGoalDocumentId(_ value: String)
}

protocol GoalPostEditPresenterView: class {
    var disposeBag: DisposeBag! { get }
    
    func inject(ui: GoalPostEditUI,
                presenter: GoalPostEditPresenter,
                routing: GoalPostEditRouting,
                disposeBag: DisposeBag)
    func didPostSuccess()
    func didSelectSegment(with index: Int)
    func showError(message: String)
    func updateLoading(_ isLoading: Bool)
}
