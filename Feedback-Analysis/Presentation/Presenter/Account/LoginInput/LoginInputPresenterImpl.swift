import Foundation
import RxSwift
import RxCocoa

class LoginInputPresenterImpl: LoginInputPresenter {
    weak var view: LoginInputPresenterView!
    var isLoading: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    private var useCase: LoginUseCase
    
    init(useCase: LoginUseCase) {
        self.useCase = useCase
    }
    
    func login(email: String, pass: String) {
        view.updateLoading(true)
        useCase.login(email: email, pass: pass)
            .subscribe { result in
                switch result {
                case .success(let account):
                    self.view.updateLoading(false)
                    AppUserDefaults.setAuthToken(token: account.authToken)
                    AppUserDefaults.setAccountEmail(email: account.email)
                    self.view.didLoginSuccess(account: account)
                case .error(let error):
                    self.view.updateLoading(false)
                    self.view.showError(message: error.localizedDescription)
                }
            }.disposed(by: view.disposeBag)
    }
    
    func setup() {}
}
