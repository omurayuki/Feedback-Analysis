import Foundation
import UIKit
import RxSwift

protocol EmailEditingRouting: Routing {
    func dismiss()
}

final class EmailEditingRoutingImpl: EmailEditingRouting {
    
    var viewController: UIViewController?
    
    func dismiss() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
