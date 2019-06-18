import Foundation
import RxSwift
import RxCocoa

class EmailEditingPresenterImpl: EmailEditingPresenter {
    
    var view: EmailEditingPresenterView!
    
    var isLoading: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    
    var useCase: SettingsUseCase!
    
    init(useCase: SettingsUseCase) {
        self.useCase = useCase
    }
    
    func update(with email: String) {
        view.updateLoading(true)
        useCase.update(with: email)
            .subscribe { result in
                switch result {
                case .success(_):
                    self.view.updateLoading(false)
                    AppUserDefaults.setAccountEmail(email: email)
                    self.view.didUpdateSuccess()
                case .error(let error):
                    self.view.updateLoading(false)
                    self.view.showError(message: error.localizedDescription)
                }
            }.disposed(by: view.disposeBag)
    }
    
    func setup() {}
}
