import Foundation
import UIKit
import RxSwift
import RxCocoa

class LoginViewControler: UIViewController {
    
    var ui: LoginUI!
    
    var routing: LoginRouting!
    
    var disposeBag: DisposeBag! {
        didSet {
            ui.faceBookBtn.rx.tap.asDriver()
                .drive(onNext: { _ in
                    
                }).disposed(by: disposeBag)
            
            ui.twitterBtn.rx.tap.asDriver()
                .drive(onNext: { _ in
                    
                }).disposed(by: disposeBag)
            
            ui.mailBtn.rx.tap.asDriver()
                .drive(onNext: { [unowned self] _ in
                    self.view.isHidden = true
                    self.routing.loginWithEmail()
                }).disposed(by: disposeBag)
        }
    }
    
    func inject(ui: LoginUI, disposeBag: DisposeBag, routing: LoginRouting) {
        self.ui = ui
        self.disposeBag = disposeBag
        self.routing = routing
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ui.setup()
    }
}
