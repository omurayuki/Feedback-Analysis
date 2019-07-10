import Foundation
import UIKit
import RxSwift

protocol PublicGoalRouting: Routing {
    func showDetail(with timeline: Timeline, height: CGFloat)
}

final class PublicGoalRoutingImpl: PublicGoalRouting {
    
    var viewController: UIViewController?
    
    func showDetail(with timeline: Timeline, height: CGFloat) {
        print("detail")
    }
}
