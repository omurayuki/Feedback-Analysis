import Foundation
import UIKit
import RxSwift
import RxCocoa

class MypageViewController: UIViewController {
    
    typealias DataSource = PageViewDataSource<UIViewController>
    
    private(set) lazy var dataSource: DataSource = {
        return DataSource(controllers: self.viewControllers)
    }()
    
    var ui: MypageUI!
    
    var routing: MypageRouting!
    
    var viewControllers: [UIViewController]!
    
    var presenter: MypagePresenter! {
        didSet {
            presenter.view = self
        }
    }
    
    var disposeBag: DisposeBag! {
        didSet {
            ui.settingsBtn.rx.tap.asDriver()
                .drive(onNext: { [unowned self] _ in
                    self.routing.moveSettingsPage()
                }).disposed(by: disposeBag)
            
            ui.follow.rx.tap.asDriver()
                .drive(onNext: { [unowned self] _ in
                    self.routing.showFollowListPage()
                }).disposed(by: disposeBag)
            
            ui.follower.rx.tap.asDriver()
                .drive(onNext: { [unowned self] _ in
                    self.routing.showFollowListPage()
                }).disposed(by: disposeBag)
            
            ui.editBtn.rx.tap.asDriver()
                .drive(onNext: { [unowned self] _ in
                    self.routing.moveEditPage()
                }).disposed(by: disposeBag)
            
            ui.goalPostBtn.rx.tap.asDriver()
                .drive(onNext: { [unowned self] _ in
                    self.routing.moveGoalPostPage()
                }).disposed(by: disposeBag)
        }
    }
    
    func inject(ui: MypageUI,
                presenter: MypagePresenter,
                routing: MypageRouting,
                viewControllers: [UIViewController],
                disposeBag: DisposeBag) {
        self.ui = ui
        self.presenter = presenter
        self.routing = routing
        self.viewControllers = viewControllers
        self.disposeBag = disposeBag
        
        fetchMypage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchMypage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ui.setup()
        ui.timelinePages.setViewControllers([viewControllers.first!], direction: .forward, animated: true, completion: nil)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if let index = presenter.currentStateIndex {
            ui.timelineSegmented.setIndex(index: index)
        }
    }
}

extension MypageViewController: MypagePresenterView {
    
    func updateLoading(_ isLoading: Bool) {
        presenter.isLoading.accept(isLoading)
    }
    
    func didFetchUserData(user: User) {
        presenter.set(user: [user])
        ui.updateUser(user: user)
    }
    
    func didSelectSegment(with index: Int) {
        if presenter.previousIndex < index {
            ui.timelinePages.setViewControllers([viewControllers[index]], direction: .forward, animated: true, completion: nil)
        } else {
            ui.timelinePages.setViewControllers([viewControllers[index]], direction: .reverse, animated: true, completion: nil)
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
            ui.timelineSegmented.setIndex(index: index)
        }
    }
}

extension MypageViewController {
    
    func fetchMypage() {
        self.presenter.getAuthorToken { [unowned self] token in
            self.presenter.fetch(to: .userRef(authorToken: token), completion: nil)
        }
    }
}

extension MypageViewController: UpdatingDelegate {
    
    func updateMypage(completion: @escaping () -> Void) {
        presenter.getAuthorToken { [unowned self] token in
            self.presenter.fetch(to: .userRef(authorToken: token)) {
                completion()
            }
        }
    }
}
