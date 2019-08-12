import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol AnalysisWrapPresenter: Presenter {
    var pendingIndex: Int? { get set }
    var currentIndex: Int? { get set }
    var previousIndex: Int { get set }
    var view: AnalysisWrapPresenterView! { get set }
    var isLoading: BehaviorRelay<Bool> { get }
}

protocol AnalysisWrapPresenterView: class {
    var disposeBag: DisposeBag! { get }
    
    func inject(ui: AnalysisWrapUI,
                presenter: AnalysisWrapPresenter,
                routing: AnalysisWrapRouting,
                viewControllers: [UIViewController],
                disposeBag: DisposeBag)
    func didSelectSegment(with index: Int)
    func willTransitionTo(_ pageViewController: UIPageViewController, pendingViewControllers: [UIViewController])
    func didFinishAnimating(_ pageViewController: UIPageViewController, finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool)
    func showError(message: String)
}
