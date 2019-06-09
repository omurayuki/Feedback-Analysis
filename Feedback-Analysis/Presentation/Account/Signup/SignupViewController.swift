import Foundation
import UIKit
import RxSwift
import RxCocoa

class SignupViewControler: UIViewController {
    
    var ui: SignupUI!
    
    var routing: SignupRouting!
    
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
                    self.routing.signupWithEmail()
                }).disposed(by: disposeBag)
        }
    }
    
    func inject(ui: SignupUI, disposeBag: DisposeBag, routing: SignupRouting) {
        self.ui = ui
        self.disposeBag = disposeBag
        self.routing = routing
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ui.setup()
    }
}
