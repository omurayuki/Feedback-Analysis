import Foundation
import UIKit
import RxSwift
import RxCocoa

class PasswordEditingViewController: UIViewController {
    
    var ui: PasswordEditingUI!
    
    var routing: PasswordEditingRouting!
    
    var presenter: PasswordEditingPresenter! {
        didSet {
            presenter.view = self
        }
    }
    
    var disposeBag: DisposeBag! {
        didSet {
            ui.updateBtn.rx.tap.asDriver()
                .drive(onNext: { _ in
                    self.validateAccount(email: self.ui.emailField.text ?? "",
                                         pass: self.ui.oldPasswordField.text ?? "",
                                         rePass: self.ui.newPasswordField.text ?? "",
                                         account: { _email, _old, _new in
                        self.presenter.update(with: _email, oldPass: _old, newPass: _new)
                    })
                }).disposed(by: disposeBag)
            
            presenter.isLoading
                .subscribe(onNext: { [unowned self] isLoading in
                    self.view.endEditing(true)
                    self.setIndicator(show: isLoading)
                }).disposed(by: disposeBag)
        }
    }
    
    func inject(ui: PasswordEditingUI,
                routing: PasswordEditingRouting,
                presenter: PasswordEditingPresenter,
                disposeBag: DisposeBag) {
        self.ui = ui
        self.routing = routing
        self.presenter = presenter
        self.disposeBag = disposeBag
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ui.setup()
    }
}

extension PasswordEditingViewController: PasswordEditingPresenterView {
    
    func updateLoading(_ isLoading: Bool) {
        presenter.isLoading.accept(isLoading)
    }
}
