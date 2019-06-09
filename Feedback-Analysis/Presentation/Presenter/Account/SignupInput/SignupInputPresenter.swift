import Foundation
import RxSwift

protocol SignupInputPresenter: Presenter {
    var view: SignupInputPresenterView! { get set }
    
    func signup(mail: String, password: String)
}

protocol SignupInputPresenterView: class {
    var disposeBag: DisposeBag! { get }
    
    func inject(ui: SignupInputUI, disposeBag: DisposeBag, routing: SignupInputRouting)
}
