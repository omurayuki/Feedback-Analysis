import Foundation
import UIKit
import RxSwift
import RxCocoa

class RemindViewController: UIViewController {
    
    var ui: RemindUI!
    
    var routing: RemindRouting!
    
    var presenter: RemindPresenter! {
        didSet {
            presenter.view = self
        }
    }
    
    var disposeBag: DisposeBag! {
        didSet {
            ui.submitBtn.rx.tap.asDriver()
                .drive(onNext: { [unowned self] _ in
                    self.validateAccount(email: self.ui.mailField.text ?? "",
                                         account: { _email, _ in
                        self.presenter.reissuePassword(email: _email)
                    })
                }).disposed(by: disposeBag)
            
            presenter.isLoading
                .subscribe(onNext: { isLoading in
                    self.view.endEditing(true)
                    self.setIndicator(show: isLoading)
                }).disposed(by: disposeBag)
        }
    }
    
    func inject(ui: RemindUI,
                presenter: RemindPresenter,
                disposeBag: DisposeBag,
                routing: RemindRouting) {
        self.ui = ui
        self.presenter = presenter
        self.routing = routing
        self.disposeBag = disposeBag
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ui.setup()
    }
}

extension RemindViewController: RemindPresenterView {
    
    func updateLoading(_ isLoading: Bool) {
        presenter.isLoading.accept(isLoading)
    }
    
    func didSubmitSuccess() {
        self.routing.dismiss()
    }
}
