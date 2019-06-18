import Foundation
import UIKit
import RxSwift
import RxCocoa

class LoginInputViewController: UIViewController {
    
    var ui: LoginInputUI!
    
    var routing: LoginInputRouting!
    
    var presenter: LoginInputPresenter! {
        didSet {
            presenter.view = self
        }
    }
    
    var disposeBag: DisposeBag! {
        didSet {
            ui.loginBtn.rx.tap.asDriver()
                .drive(onNext: { [unowned self] _ in
                    self.validateAccount(email: self.ui.mailField.text ?? "",
                                         pass: self.ui.passField.text ?? "",
                                         account: { _email, _pass, _  in
                        self.presenter.login(email: _email, pass: _pass)
                    })
                }).disposed(by: disposeBag)
            
            ui.passRemindBtn.rx.tap.asDriver()
                .drive(onNext: { _ in
                    self.routing.moveRemindPage()
                }).disposed(by: disposeBag)
            
            presenter.isLoading
                .subscribe(onNext: { [unowned self] isLoading in
                    self.view.endEditing(true)
                    self.setIndicator(show: isLoading)
                }).disposed(by: disposeBag)
        }
    }
    
    func inject(ui: LoginInputUI,
                presenter: LoginInputPresenter,
                disposeBag: DisposeBag,
                routing: LoginInputRouting) {
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

extension LoginInputViewController: LoginInputPresenterView {
    
    func updateLoading(_ isLoading: Bool) {
        presenter.isLoading.accept(isLoading)
    }
    
    func didLoginSuccess(account: Account) {
        routing.moveMainPage()
    }
}
