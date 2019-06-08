import Foundation
import UIKit
import RxSwift
import RxCocoa

class LoginViewControler: UIViewController {
    
    var ui: LoginUI!
    
    var disposedBag: DisposeBag!
    
    func inject(dispose: DisposeBag, ui: LoginUI) {
        self.disposedBag = dispose
        self.ui = ui
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        ui.setup()
    }
}
