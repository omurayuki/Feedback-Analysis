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
    
    func follow(documentRef: FirebaseDocumentRef, completion: @escaping () -> Void) {
        useCase.follow(documentRef: documentRef)
            .subscribe { result in
                switch result {
                case .success(_):
                    completion()
                case .error(let error):
                    self.view.showError(message: error.localizedDescription)
                }
            }.disposed(by: view.disposeBag)
    }
    
    func unFollow(documentRef: FirebaseDocumentRef, completion: @escaping () -> Void) {
        useCase.unFollow(documentRef: documentRef)
            .subscribe { result in
                switch result {
                case .success(_):
                    completion()
                case .error(let error):
                    self.view.showError(message: error.localizedDescription)
                }
            }.disposed(by: view.disposeBag)
    }
    
    func checkFollowing(documentRef: FirebaseDocumentRef, completion: @escaping (Bool) -> Void) {
        useCase.checkFollowing(documentRef: documentRef)
            .subscribe { result in
                switch result {
                case .success(let response):
                    completion(response)
                case .error(let error):
                    self.view.showError(message: error.localizedDescription)
                }
            }.disposed(by: view.disposeBag)
    }
    
    func setObjectToken(_ token: String) {
        useCase.setObjectToken(token)
            .subscribe { result in
                switch result {
                case .success(_):
                    return
                case .error(let error):
                    self.view.showError(message: error.localizedDescription)
                }
            }.disposed(by: view.disposeBag)
    }
    
    //// subjectToken, objectTokenの両方を一気に取得するとcallback地獄になりにくいと思った
    func getBothToken(completion: @escaping (String, String) -> Void) {
        useCase.getBothToken()
            .subscribe { [unowned self] result in
                switch result {
                case .success(let response):
                    completion(response.0, response.1)
                case .error(let error):
                    self.view.showError(message: error.localizedDescription)
                }
            }.disposed(by: view.disposeBag)
    }
    
    func getConversations(queryRef: FirebaseQueryRef,
                          completion: @escaping ([Conversation]) -> Void) {
        useCase.getConversations(queryRef: queryRef)
            .subscribe { [unowned self] result in
                switch result {
                case .success(let response):
                    completion(response)
                case .error(let error):
                    self.view.showError(message: error.localizedDescription)
                }
            }.disposed(by: view.disposeBag)
    }
    
    func setConversation(_ conversation: Conversation) {
        
    }
    
    func getConversation(completion: @escaping (Conversation) -> Void) {
        
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
