import Foundation
import UIKit

protocol GoalPostEditRouting: Routing {
    func dismiss()
}

final class GoalPostEditRoutingImpl: GoalPostEditRouting {
    
    var viewController: UIViewController?
    
    func dismiss() {
        viewController?.dismiss(animated: true)
    }
}
