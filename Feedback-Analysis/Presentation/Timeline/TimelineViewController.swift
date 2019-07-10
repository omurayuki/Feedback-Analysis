import Foundation
import UIKit
import RxSwift
import RxCocoa

final class TimelineViewController: UIViewController {
    
    var ui: TimelineUI!
    
    var routing: TimelineRouting!
    
    var viewControllers: [UIViewController]!
    
    var presenter: TimelinePresenter! {
        didSet {
            presenter.view = self
        }
    }
    
    var disposeBag: DisposeBag! {
        didSet {
            ui.searchBtn.rx.tap.asDriver()
                .drive(onNext: { [unowned self] _ in
                    self.routing.showSearchPage()
                }).disposed(by: disposeBag)
        }
    }
    
    func inject(ui: TimelineUI,
                presenter: TimelinePresenter,
                routing: TimelineRouting,
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
    }
}

extension TimelineViewController: TimelinePresenterView {
    
    func didSelectSegment(with index: Int) {
        print("ok")
    }
    
    func willTransitionTo(_ pageViewController: UIPageViewController, pendingViewControllers: [UIViewController]) {
        print("ok")
    }
    
    func didFinishAnimating(_ pageViewController: UIPageViewController, finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        print("ok")
    }
}


extension TimelineViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return UIViewController()
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return UIViewController()
    }
}
