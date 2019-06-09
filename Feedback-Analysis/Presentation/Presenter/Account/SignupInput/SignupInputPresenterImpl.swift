import Foundation
import RxSwift
import UIKit

class SignupInputPresenterImpl: SignupInputPresenter {
    weak var view: SignupInputPresenterView!
    
    
    func signup(mail: String, password: String) {
        print("ok")
    }
    
    func setup() {
        print("ok")
    }
}

//class LoginPresenterImpl: LoginPresenter {
//    weak var view: LoginPresenterView!
//    private var useCase: LoginUseCase
//
//    init(useCase: LoginUseCase) {
//        self.useCase = useCase
//    }
//
//    func setup() {
//
//    }
//
//    func login(email: String, password: String) {
//        useCase.login(email: email, password: password)
//            .subscribe(onSuccess: { (account) in
//                AppUserDefaults.setAccountEmail(email: account.email)
//                AppUserDefaults.setAuthToken(token: account.authToken)
//                self.view.didLoginSuccess(email: account.email)
//            }, onError: { error in
//                self.view.showError(message: self.useCase.getLoginErrorMessage(statusCode: ErrorChecker.getStatusCode(error: error)))
//            })
//            .disposed(by: view.disposeBag)
//    }
//}
