import Foundation
import RxSwift
import RxCocoa
import UIKit

class TopViewController: UIViewController {
    
    var ui: TopUI!
    
    var routing: TopRouting!
    
    var disposeBag: DisposeBag! {
        didSet {
            ui.loginBtn.rx.tap.asDriver()
                .drive(onNext: { _ in
                    self.routing.login()
                }).disposed(by: disposeBag)
            
            ui.signupBtn.rx.tap.asDriver()
                .drive(onNext: { _ in
                    self.routing.signup()
                }).disposed(by: disposeBag)
        }
    }
    
    func inject(ui: TopUI,
                routing: TopRouting,
                disposeBag: DisposeBag) {
        self.ui = ui
        self.routing = routing
        self.disposeBag = disposeBag
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ui?.setup()
    }
}
