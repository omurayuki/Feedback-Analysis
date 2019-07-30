import Foundation
import UIKit
import RxSwift
import RxCocoa

//// 

class OtherPersonPageViewController: UIViewController {
    
    typealias DataSource = PageViewDataSource<UIViewController>
    
    private(set) lazy var dataSource: DataSource = {
        return DataSource(controllers: self.viewControllers)
    }()
    
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
            ui.followBtn.rx.tap.asDriver()
                .drive(onNext: { [unowned self] _ in
                    self.presenter.getBothToken(completion: { [unowned self] subjectToken, objectToken in
                        let ref: FirebaseDocumentRef = .followRef(subject: subjectToken, object: objectToken)
                        self.ui.followBtn.currentState == .following ? self.unFollow(documentRef: ref) : self.follow(documentRef: ref)
                    })
                }).disposed(by: disposeBag)
            
            ui.follow.rx.tap.asDriver()
                .drive(onNext: { [unowned self] _ in
                    self.routing.showFollowListPage()
                }).disposed(by: disposeBag)
            
            ui.follower.rx.tap.asDriver()
                .drive(onNext: { [unowned self] _ in
                    self.routing.showFollowListPage()
                }).disposed(by: disposeBag)
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
        presenter.setObjectToken(token)
        checkFollowing(objectToken: token)
        presenter.fetch(to: .userRef(authorToken: token), completion: nil)
    }
    
    func follow(documentRef: FirebaseDocumentRef) {
        presenter.follow(documentRef: documentRef) {
            self.ui.followBtn.currentState = .following
        }
    }
    
    func unFollow(documentRef: FirebaseDocumentRef) {
        presenter.unFollow(documentRef: documentRef) {
            self.ui.followBtn.currentState = .unFollowing
        }
    }
    
    func checkFollowing(objectToken: String) {
        presenter.getAuthorToken { [unowned self] subjectToken in
            self.presenter.checkFollowing(documentRef: .followRef(subject: subjectToken, object: objectToken)) { bool in
                bool ? (self.ui.followBtn.currentState = .following) : (self.ui.followBtn.currentState = .unFollowing)
            }
        }
    }
}
