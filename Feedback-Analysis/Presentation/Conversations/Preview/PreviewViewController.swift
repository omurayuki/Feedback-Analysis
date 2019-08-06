import Foundation
import UIKit
import RxSwift
import RxCocoa

final class PreviewViewController: UIViewController {
    
    var imageURLString: String?
    
    var ui: PreviewUI!
    
    var routing: PreviewRouting!
    
    var disposeBag: DisposeBag! {
        didSet {
            ui.cancelBtn.rx.tap.asDriver()
                .drive(onNext: { [unowned self] gesture in
                    self.routing.dismiss()
                }).disposed(by: disposeBag)
        }
    }
    
    func inject(ui: PreviewUI,
                routing: PreviewRouting,
                disposeBag: DisposeBag) {
        self.ui = ui
        self.routing = routing
        self.disposeBag = disposeBag
        
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overFullScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let imageURLString = imageURLString else { return }
        ui.setup(image: UIImage(url: imageURLString) ?? UIImage())
    }
}
