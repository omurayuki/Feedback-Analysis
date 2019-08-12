import Foundation
import UIKit
import RxSwift

protocol AnalysisListRouting: Routing {
    func showAnalysisPage()
}

final class AnalysisListRoutingImpl: AnalysisListRouting {
    
    var viewController: UIViewController?

    func showAnalysisPage() {
        print("hoge")
    }
}
