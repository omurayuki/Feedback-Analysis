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
            .subscribe { [unowned self]  result in
                switch result {
                case .success(let account):
                    self.view.didSignupSuccess(account: account)
                case .error(let error):
                    self.view.updateLoading(false)
                    self.view.showError(message: error.localizedDescription)
                }
            }.disposed(by: view.disposeBag)
    }
    
    func setData(documentRef: FirebaseDocumentRef, fields: [String : Any]) {
        useCase.setData(documentRef: documentRef, fields: fields)
            .subscribe { [unowned self] result in
                switch result {
                case .success(_):
                    self.view.updateLoading(false)
                    self.view.didSaveUserData()
                case .error(let error):
                    self.view.updateLoading(false)
                    self.view.showError(message: error.localizedDescription)
                }
            }.disposed(by: view.disposeBag)
    }
    
    func getAuthorToken(completion: @escaping (String) -> Void) {
        useCase.getAuthorToken()
            .subscribe { [unowned self]  result in
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
