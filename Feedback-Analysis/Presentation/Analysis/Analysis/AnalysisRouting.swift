import Foundation
import UIKit
import RxSwift

protocol AnalysisRouting: Routing {
    func dismiss()
}

final class AnalysisRoutingImpl: AnalysisRouting {
    
    var viewController: UIViewController?
    
    func dismiss() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
