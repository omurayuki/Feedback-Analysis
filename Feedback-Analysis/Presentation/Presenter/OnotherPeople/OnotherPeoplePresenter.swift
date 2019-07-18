import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol OnotherPeoplePresenter: Presenter {
    var pendingIndex: Int? { get set }
    var currentIndex: Int? { get set }
    var previousIndex: Int { get set }
    var view: OnotherPeoplePresenterView! { get set }
    var isLoading: BehaviorRelay<Bool> { get }
    
    func fetch(to documentRef: FirebaseDocumentRef, completion: (() -> Void)?)
    func getAuthorToken(completion: @escaping (String) -> Void)
}

protocol OnotherPeoplePresenterView: class {
    var disposeBag: DisposeBag! { get }
    
    func inject(ui: OnotherPeopleUI,
                presenter: OnotherPeoplePresenter,
                routing: OnotherPeopleRouting,
                viewControllers: [UIViewController],
                disposeBag: DisposeBag)
    func didFetchUserData(user: User)
    func didSelectSegment(with index: Int)
    func willTransitionTo(_ pageViewController: UIPageViewController, pendingViewControllers: [UIViewController])
    func didFinishAnimating(_ pageViewController: UIPageViewController, finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool)
    func showError(message: String)
    func updateLoading(_ isLoading: Bool)
}
