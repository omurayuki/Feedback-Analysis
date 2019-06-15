import Foundation
import RxSwift
import RxCocoa

class EditPresenterImpl: EditPresenter {
    var view: EditPresenterView!
    
    var isLoading: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    
    private var useCase: EditUseCase
    
    init(useCase: EditUseCase) {
        self.useCase = useCase
    }
    
    func update(to documentRef: FirebaseDocumentRef, user: Update) {
        view.updateLoading(true)
        useCase.update(to: documentRef, user: user)
            .subscribe { result in
                switch result {
                case .success(_):
                    self.view.updateLoading(false)
                    self.view.didEditUserData()
                case .error(let error):
                    self.view.updateLoading(false)
                    self.view.showError(message: error.localizedDescription)
                }
            }.disposed(by: view.disposeBag)
    }
    
    func setup() {}
}
