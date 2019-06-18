import Foundation
import RxSwift

class SettingsPresenterImpl: SettingsPresenter {
    
    var view: SettingsPresenterView!
    
    var useCase: SettingsUseCase!
    
    init(useCase: SettingsUseCase) {
        self.useCase = useCase
    }
    
    func logout() {
        useCase.logout()
            .subscribe { result in
                switch result {
                case .success(_):
                    self.view.didLogoutSuccess()
                case .error(let error):
                    self.view.showError(message: error.localizedDescription)
                }
            }.disposed(by: view.disposeBag)
    }
    
    func setup() {}
}
