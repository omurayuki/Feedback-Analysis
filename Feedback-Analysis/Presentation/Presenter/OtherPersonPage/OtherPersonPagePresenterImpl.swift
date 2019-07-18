import Foundation
import RxSwift
import RxCocoa

class OtherPersonPagePresenterImpl: NSObject, OtherPersonPagePresenter {
    
    var pendingIndex: Int?
    var currentIndex: Int?
    var previousIndex = 0
    
    var view: OtherPersonPagePresenterView!
    
    var isLoading: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    
    private var useCase: OtherPersonPageUseCase
    
    init(useCase: OtherPersonPageUseCase) {
        self.useCase = useCase
    }
    
    func fetch(to documentRef: FirebaseDocumentRef, completion: (() -> Void)? = nil) {
        self.view.updateLoading(true)
        useCase.fetch(to: documentRef)
            .subscribe { [unowned self] result in
                switch result {
                case .success(let response):
                    self.view.updateLoading(false)
                    self.view.didFetchUserData(user: response)
                    completion?()
                case .error(let error):
                    self.view.updateLoading(false)
                    self.view.showError(message: error.localizedDescription)
                }
            }.disposed(by: view.disposeBag)
    }
    
    func getAuthorToken(completion: @escaping (String) -> Void) {
        useCase.getAuthorToken()
            .subscribe { [unowned self] result in
                switch result {
                case .success(let response):
                    completion(response)
                case .error(let error):
                    self.view.showError(message: error.localizedDescription)
                }
            }.disposed(by: view.disposeBag)
    }
    
    func setup() {}
}

extension OtherPersonPagePresenterImpl: CustomSegmentedControlDelegate {
    
    func changeToIndex(index: Int) {
        view.didSelectSegment(with: index)
    }
}

extension OtherPersonPagePresenterImpl: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        view.willTransitionTo(pageViewController, pendingViewControllers: pendingViewControllers)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        view.didFinishAnimating(pageViewController, finished: finished, previousViewControllers: previousViewControllers, transitionCompleted: completed)
    }
}
