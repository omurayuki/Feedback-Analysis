import Foundation
import UIKit
import RxSwift

protocol ReplyRouting: Routing {
    func dismiss()
}

final class ReplyRoutingImpl: ReplyRouting {
    
    var viewController: UIViewController?
    
    func dismiss() {
        viewController?.dismiss(animated: true)
    }
}
