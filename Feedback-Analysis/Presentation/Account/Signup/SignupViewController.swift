import Foundation
import UIKit
import RxSwift
import RxCocoa

class SignupViewControler: UIViewController {
    
    var ui: SignupUI!
    
    var disposedBag: DisposeBag!
    
    func inject(dispose: DisposeBag, ui: SignupUI) {
        self.disposedBag = dispose
        self.ui = ui
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        ui.setup()
    }
}
