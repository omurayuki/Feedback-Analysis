import Foundation
import UIKit
import RxSwift
import RxCocoa

final class AnalysisWrapViewController: UIViewController {
    
    typealias DataSource = PageViewDataSource<UIViewController>
    
    private(set) lazy var dataSource: DataSource = {
        return DataSource(controllers: self.viewControllers)
    }()
    
    var ui: AnalysisWrapUI!
    
    var routing: AnalysisWrapRouting!
    
    var viewControllers: [UIViewController]!
    
    var presenter: AnalysisWrapPresenter! {
        didSet {
            presenter.view = self
        }
    }
    
    var disposeBag: DisposeBag! {
        didSet {}
    }
    
    func inject(ui: AnalysisWrapUI,
                presenter: AnalysisWrapPresenter,
                routing: AnalysisWrapRouting,
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
        ui.pages.setViewControllers([viewControllers.first!], direction: .forward, animated: true, completion: nil)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if let index = presenter.currentStateIndex {
            ui.segmented.setIndex(index: index)
        }
    }
}

extension AnalysisWrapViewController: AnalysisWrapPresenterView {
    
    func didSelectSegment(with index: Int) {
        if presenter.previousIndex < index {
            ui.pages.setViewControllers([viewControllers[index]], direction: .forward, animated: true, completion: nil)
        } else {
            ui.pages.setViewControllers([viewControllers[index]], direction: .reverse, animated: true, completion: nil)
        }
        presenter.previousIndex = index
        presenter.currentStateIndex = index
    }
    
    func willTransitionTo(_ pageViewController: UIPageViewController, pendingViewControllers: [UIViewController]) {
        presenter.pendingIndex = viewControllers.firstIndex(of: pendingViewControllers.first!)
    }
    
    func didFinishAnimating(_ pageViewController: UIPageViewController, finished: Bool,
                            previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed else { return }
        presenter.currentIndex = presenter.pendingIndex
        presenter.currentStateIndex = presenter.pendingIndex
        if let index = presenter.currentIndex {
            ui.segmented.setIndex(index: index)
        }
    }
}
