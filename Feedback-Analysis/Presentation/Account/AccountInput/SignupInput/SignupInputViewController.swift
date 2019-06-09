import UIKit
import RxSwift
import RxCocoa

class SignupInputViewController: UIViewController {
    
    var ui: SignupInputUI!
    
    var routing: SignupInputRouting!
    
    var disposeBag: DisposeBag! {
        didSet {
            ui.cancelBtn.rx.tap.asDriver()
                .drive(onNext: { [unowned self] _ in
                    self.routing.cancel()
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
