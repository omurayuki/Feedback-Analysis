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
            ui.signupBtn.rx.tap.asDriver()
                .drive(onNext: { [unowned self] _ in
                    self.validateAccount(email: self.ui.mailField.text ?? "",
                                         pass: self.ui.passField.text ?? "",
                                         account: { _email, _pass in
                        self.presenter.signup(email: _email, pass: _pass)
                    })
                }).disposed(by: disposeBag)
            
            presenter.isLoading
                .subscribe(onNext: { [unowned self] isLoading in
                    self.view.endEditing(true)
                    self.setIndicator(show: isLoading)
                }).disposed(by: disposeBag)
        }
    }
    
    func inject(ui: SignupInputUI,
                presenter: SignupInputPresenter,
                disposeBag: DisposeBag,
                routing: SignupInputRouting) {
        self.ui = ui
        self.presenter = presenter
        self.disposeBag = disposeBag
        self.routing = routing
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ui.setup()
    }
}

extension SignupInputViewController: SignupInputPresenterView {
    
    func updateLoading(_ isLoading: Bool) {
        presenter.isLoading.accept(isLoading)
    }
    
    func didSignupSuccess(account: Account) {
        routing.moveMainPage()
    }
}
