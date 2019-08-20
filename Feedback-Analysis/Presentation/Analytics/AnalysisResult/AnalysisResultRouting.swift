import Foundation
import UIKit
import RxSwift

protocol AnalysisResultRouting: Routing {
    func showCompletesPage()
}

final class AnalysisResultRoutingImpl: AnalysisResultRouting {
    
    var viewController: UIViewController?
    
    func showCompletesPage() {
        print("")
    }
}
