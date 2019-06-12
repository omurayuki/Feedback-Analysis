import Foundation
import UIKit

protocol RemindRouting: Routing {
    func dismiss()
}

final class RemindRoutingImpl: RemindRouting {
    
    var viewController: UIViewController?
    
    func dismiss() {
        viewController?.dismissOrPopViewController()
    }
}
