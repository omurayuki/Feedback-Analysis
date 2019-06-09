import UIKit
import RxSwift
import RxCocoa

class SignupInputViewController: UIViewController {
    
    var ui: SignupInputUI!
    
    var routing: SignupInputRouting!
    
    var presenter: SignupInputPresenter! {
        didSet {
            presenter.view = self
        }
    }
    
    var disposeBag: DisposeBag! {
        didSet {
            ui.cancelBtn.rx.tap.asDriver()
                .drive(onNext: { [unowned self] _ in
                    self.routing.cancel()
                }).disposed(by: disposeBag)
            
            ui.signupBtn.rx.tap.asDriver()
                .drive(onNext: { [unowned self] _ in
                    switch Validate.validateAccount(mail: self.ui.mailField.text ?? "",
                                                    pass: self.ui.passField.text ?? "") {
                    case .mailNotEnough(let str):     self.showError(message: str)
                    case .mailExceeded(let str):      self.showError(message: str)
                    case .passNotEnough(let str):     self.showError(message: str)
                    case .passExceeded(let str):      self.showError(message: str)
                    case .notAccurateChar(let str):   self.showError(message: str)
                    case .ok(let mail, let pass):     self.presenter.signup(mail: mail, password: pass)
                    }
                }).disposed(by: disposeBag)
        }
    }
    
    func inject(ui: SignupInputUI, disposeBag: DisposeBag, routing: SignupInputRouting) {
        self.ui = ui
        self.disposeBag = disposeBag
        self.routing = routing
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ui.setup()
    }
}

extension SignupInputViewController: SignupInputPresenterView {}

// usercase
// repository
// datastore
// entity

