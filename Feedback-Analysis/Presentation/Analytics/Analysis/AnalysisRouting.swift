import Foundation
import UIKit
import RxSwift

protocol AnalysisRouting: Routing {
    func dismiss()
}

final class AnalysisRoutingImpl: AnalysisRouting {
    
    var viewController: UIViewController?
    
    func dismiss() {
        viewController?.dismiss(animated: true)
    }
}
