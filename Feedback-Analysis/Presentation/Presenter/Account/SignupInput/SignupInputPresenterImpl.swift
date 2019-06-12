import Foundation
import UIKit
import RxSwift
import RxCocoa

class SignupInputPresenterImpl: SignupInputPresenter {
    weak var view: SignupInputPresenterView!
    var isLoading: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    private var useCase: SignupUseCase
    
    init(useCase: SignupUseCase) {
        self.useCase = useCase
    }
    
    func signup(email mail: String, pass: String) {
        view.updateLoading(true)
        useCase.signup(email: mail, pass: pass)
            .subscribe { result in
                switch result {
                case .success(let account):
                    // userdefaultsに保存処理
                    self.view.updateLoading(false)
                    self.view.didSignupSuccess(account: account)
                case .error(let error):
                    self.view.updateLoading(false)
                    self.view.showError(message: error.localizedDescription)
                }
            }.disposed(by: view.disposeBag)
    }
    
    func setup() {}
}
