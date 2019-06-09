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
            
            ui.signupBtn.rx.tap.asDriver()
                .drive(onNext: { [unowned self] _ in
                    switch Validate.validateAccount(mail: self.ui.mailInput.field.text ?? "",
                                                    pass: self.ui.passInput.field.text ?? "") {
                        
                    case .notAccurateChar(let str):
                        print(str)
                    case .mailNotEnough(let str):
                        print(str)
                    case .mailExceeded(let str):
                        print(str)
                    case .passNotEnough(let str):
                        print(str)
                    case .passExceeded(let str):
                        print(str)
                    case .ok:
                        return
                        //firebase auth
                        //
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
