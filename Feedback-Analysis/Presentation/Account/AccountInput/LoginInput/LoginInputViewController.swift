import Foundation
import UIKit
import RxSwift
import RxCocoa

class LoginInputViewController: UIViewController {
    
    var ui: LoginInputUI!
    
    var routing: LoginInputRouting!
    
    var disposeBag: DisposeBag! {
        didSet {
            ui.cancelBtn.rx.tap.asDriver()
                .drive(onNext: { [unowned self] _ in
                    self.routing.cancel()
                }).disposed(by: disposeBag)
        }
    }
    
    func inject(ui: LoginInputUI, disposeBag: DisposeBag, routing: LoginInputRouting) {
        self.ui = ui
        self.disposeBag = disposeBag
        self.routing = routing
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ui.setup()
    }
}
