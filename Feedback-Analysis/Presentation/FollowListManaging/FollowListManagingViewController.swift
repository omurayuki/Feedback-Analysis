import Foundation
import UIKit
import RxSwift
import RxCocoa

final class FollowListManagingViewController: UIViewController {
    
    var ui: FollowListManagingUI!
    
    var routing: FollowListManagingRouting!
    
    var viewControllers: [UIViewController]!
    
    var presenter: FollowListManagingPresenter! {
        didSet {
            presenter.view = self
        }
    }
    
    var disposeBag: DisposeBag! {
        didSet {
        }
    }
    
    func inject(ui: FollowListManagingUI,
                presenter: FollowListManagingPresenter,
                routing: FollowListManagingRouting,
                viewControllers: [UIViewController],
                disposeBag: DisposeBag) {
        self.ui = ui
        self.presenter = presenter
        self.routing = routing
        self.viewControllers = viewControllers
        self.disposeBag = disposeBag
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ui.setup()
        ui.followPages.setViewControllers([viewControllers.first!], direction: .forward, animated: true, completion: nil)
    }
}

extension FollowListManagingViewController: FollowListManagingPresenterView {
    
    func didSelectSegment(with index: Int) {
        if presenter.previousIndex < index {
            ui.followPages.setViewControllers([viewControllers[index]], direction: .forward, animated: true, completion: nil)
        } else {
            ui.followPages.setViewControllers([viewControllers[index]], direction: .reverse, animated: true, completion: nil)
        }
        presenter.previousIndex = index
    }
    
    func willTransitionTo(_ pageViewController: UIPageViewController, pendingViewControllers: [UIViewController]) {
        presenter.pendingIndex = viewControllers.firstIndex(of: pendingViewControllers.first!)
    }
    
    func didFinishAnimating(_ pageViewController: UIPageViewController, finished: Bool,
                            previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed else { return }
        presenter.currentIndex = presenter.pendingIndex
        if let index = presenter.currentIndex {
            ui.followSegment.setIndex(index: index)
        }
    }
}

extension FollowListManagingViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return UIPageViewController.generateViewController(viewControllerBefore: viewController,
                                                           viewControllers: viewControllers)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return UIPageViewController.generateViewController(viewControllerAfter: viewController,
                                                           viewControllers: viewControllers)
    }
}
