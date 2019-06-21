import Foundation
import UIKit

protocol GoalPostRouting: Routing {
    func dismiss()
}

final class GoalPostRoutingImpl: GoalPostRouting {
    
    var viewController: UIViewController?
    
    func dismiss() {
        viewController?.dismiss(animated: true)
    }
}
