import Foundation
import UIKit
import RxSwift
import RxCocoa

class OtherPersonPageViewController: UIViewController {
    
    var ui: OtherPersonPageUI!
    
    var routing: OtherPersonPageRouting!
    
    var viewControllers: [UIViewController]!
    
    var presenter: OtherPersonPagePresenter! {
        didSet {
            presenter.view = self
        }
    }
    
    var disposeBag: DisposeBag! {
        didSet {
        }
    }
    
    func inject(ui: OtherPersonPageUI,
                presenter: OtherPersonPagePresenter,
                routing: OtherPersonPageRouting,
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
        ui.timelinePages.setViewControllers([viewControllers.first!], direction: .forward, animated: true, completion: nil)
    }
}

extension OtherPersonPageViewController: OtherPersonPagePresenterView {
    
    func updateLoading(_ isLoading: Bool) {
        presenter.isLoading.accept(isLoading)
    }
    
    func didFetchUserData(user: User) {
        ui.updateUser(user: user)
    }
    
    func didSelectSegment(with index: Int) {
        if presenter.previousIndex < index {
            ui.timelinePages.setViewControllers([viewControllers[index]], direction: .forward, animated: true, completion: nil)
        } else {
            ui.timelinePages.setViewControllers([viewControllers[index]], direction: .reverse, animated: true, completion: nil)
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
            ui.timelineSegmented.setIndex(index: index)
        }
    }
}

extension OtherPersonPageViewController {
    
    func recieve(with token: String) {
        presenter.fetch(to: .userRef(authorToken: token), completion: nil)
    }
}

extension OtherPersonPageViewController: UIPageViewControllerDataSource {
    
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
