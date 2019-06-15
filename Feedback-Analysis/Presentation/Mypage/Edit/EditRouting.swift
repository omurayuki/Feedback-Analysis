import Foundation
import UIKit

protocol EditRouting: Routing {
    func dismiss()
}

final class EditRoutingImpl: EditRouting {
    
    var viewController: UIViewController?
    
    func dismiss() {
        viewController?.dismissAndEndEditing()
    }
}
