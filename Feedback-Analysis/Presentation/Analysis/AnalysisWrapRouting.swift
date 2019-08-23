import Foundation
import UIKit
import RxSwift

protocol AnalysisWrapRouting: Routing {}

final class AnalysisWrapRoutingImpl: AnalysisWrapRouting {
    
    var viewController: UIViewController?
}
