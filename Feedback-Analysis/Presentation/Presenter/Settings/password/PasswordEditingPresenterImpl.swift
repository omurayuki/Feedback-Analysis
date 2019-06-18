import Foundation
import RxSwift
import RxCocoa

class PasswordEditingPresenterImpl: PasswordEditingPresenter {
    
    var view: PasswordEditingPresenterView!
    
    var isLoading: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    
    var useCase: SettingsUseCase!
    
    init(useCase: SettingsUseCase) {
        self.useCase = useCase
    }
    
    func update(with email: String, oldPass: String, newPass: String) {
        view.updateLoading(true)
        useCase.update(with: email, oldPass: oldPass, newPass: newPass)
            .subscribe { result in
                switch result {
                case .success(_):
                    self.view.updateLoading(false)
                    self.view.showSuccess(message: "パスワードを変更しました")
                case .error(let error):
                    self.view.updateLoading(false)
                    self.view.showError(message: error.localizedDescription)
                }
            }.disposed(by: view.disposeBag)
    }
    
    func setup() {}
}
