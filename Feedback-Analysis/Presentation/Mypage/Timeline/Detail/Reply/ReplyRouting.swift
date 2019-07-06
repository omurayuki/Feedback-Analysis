import Foundation
import UIKit
import RxSwift

protocol ReplyRouting: Routing {}

final class ReplyRoutingImpl: ReplyRouting {
    
    var viewController: UIViewController?
    
}
