import Foundation
import UIKit
import RxSwift
import RxCocoa

class EmailEditingViewController: UIViewController {
    
    var ui: EmailEditingUI!
    
    var routing: EmailEditingRouting!
    
    var presenter: EmailEditingPresenter! {
        didSet {
            presenter.view = self
        }
    }
    
    var disposeBag: DisposeBag! {
        didSet {
            ui.updateBtn.rx.tap.asDriver()
                .drive(onNext: { [unowned self] _ in
                    self.validateAccount(email: self.ui.emailField.text ?? "",
                                         account: { _email, _, _  in
                        self.presenter.update(with: _email)
                    })
                }).disposed(by: disposeBag)
            
            presenter.isLoading
                .subscribe(onNext: { [unowned self] isLoading in
                    self.view.endEditing(true)
                    self.setIndicator(show: isLoading)
                }).disposed(by: disposeBag)
        }
    }
    
    func inject(ui: EmailEditingUI,
                routing: EmailEditingRouting,
                presenter: EmailEditingPresenter,
                disposeBag: DisposeBag) {
        self.ui = ui
        self.routing = routing
        self.presenter = presenter
        self.disposeBag = disposeBag
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.getEmail()
    }
}

extension EmailEditingViewController: EmailEditingPresenterView {
    
    func updateLoading(_ isLoading: Bool) {
        presenter.isLoading.accept(isLoading)
    }
    
    func didGet(with email: String) {
        ui.setup(with: email)
    }
}
