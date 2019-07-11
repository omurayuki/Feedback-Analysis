import Foundation
import RxSwift
import RxCocoa

protocol SignupInputPresenter: Presenter {
    var view: SignupInputPresenterView! { get set }
    var isLoading: BehaviorRelay<Bool> { get }
    
    func signup(email: String, pass: String)
    func setData(documentRef: FirebaseDocumentRef, fields: [String: Any])
    func getAuthorToken(completion: @escaping (String) -> Void)
}

protocol SignupInputPresenterView: class {
    var disposeBag: DisposeBag! { get }
    
    func inject(ui: SignupInputUI,
                presenter: SignupInputPresenter,
                disposeBag: DisposeBag,
                routing: SignupInputRouting)
    func didSignupSuccess(account: Account)
    func didSaveUserData()
    func showError(message: String)
    func updateLoading(_ isLoading: Bool)
}
