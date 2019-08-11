import Foundation
import UIKit
import RxSwift

protocol PreviewRouting: Routing {
    func dismiss()
}

final class PreviewRoutingImpl: PreviewRouting {
    
    var viewController: UIViewController?
    
    func dismiss() {
        viewController?.dismiss(animated: true)
    }
}
