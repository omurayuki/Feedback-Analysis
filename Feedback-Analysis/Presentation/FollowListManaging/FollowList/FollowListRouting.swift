import Foundation
import UIKit
import RxSwift

protocol FollowListRouting: Routing {
    func showOtherPersonPage(with: String)
}

final class FollowListRoutingImpl: FollowListRouting {
    
    var viewController: UIViewController?
    
    func showOtherPersonPage(with: String) {
        
    }
}
