import Foundation
import RxSwift
import RxCocoa

class MypagePresenterImpl: MypagePresenter {
    
    var view: MypagePresenterView!
    
    var isLoading: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    
    private var useCase: MypageUseCase
    
    init(useCase: MypageUseCase) {
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
    
    func setup() {}
}
