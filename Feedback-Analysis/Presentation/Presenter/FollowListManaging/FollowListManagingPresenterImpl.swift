import Foundation
import RxSwift
import RxCocoa

class FollowListManagingPresenterImpl: NSObject, FollowListManagingPresenter {
    
    var pendingIndex: Int?
    var currentIndex: Int?
    var previousIndex = 0
    
    var view: FollowListManagingPresenterView!
    
    var isLoading: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    
    private var useCase: FollowUseCase
    
    init(useCase: FollowUseCase) {
        self.useCase = useCase
    }
    
    func setup() {}
}

extension FollowListManagingPresenterImpl: CustomSegmentedControlDelegate {
    
    func changeToIndex(index: Int) {
        view.didSelectSegment(with: index)
    }
}

extension FollowListManagingPresenterImpl: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        view.willTransitionTo(pageViewController, pendingViewControllers: pendingViewControllers)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        view.didFinishAnimating(pageViewController, finished: finished, previousViewControllers: previousViewControllers, transitionCompleted: completed)
    }
}
