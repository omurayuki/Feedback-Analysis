import Foundation
import RxSwift
import RxCocoa

class AnalysisWrapPresenterImpl: NSObject, AnalysisWrapPresenter {
    
    var pendingIndex: Int?
    var currentIndex: Int?
    var previousIndex = 0
    
    var view: AnalysisWrapPresenterView!
    
    var isLoading: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    
    private var useCase: TimelineUseCase
    
    init(useCase: TimelineUseCase) {
        self.useCase = useCase
    }
    
    func setup() {}
}

extension AnalysisWrapPresenterImpl: CustomSegmentedControlDelegate {
    
    func changeToIndex(index: Int) {
        view.didSelectSegment(with: index)
    }
}

extension AnalysisWrapPresenterImpl: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        view.willTransitionTo(pageViewController, pendingViewControllers: pendingViewControllers)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        view.didFinishAnimating(pageViewController, finished: finished, previousViewControllers: previousViewControllers, transitionCompleted: completed)
    }
}
