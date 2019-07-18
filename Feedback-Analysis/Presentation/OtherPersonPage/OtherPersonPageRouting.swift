import Foundation
import UIKit
import RxSwift

protocol OtherPersonPageRouting: Routing {
}

final class OtherPersonPageRoutingImpl: OtherPersonPageRouting {
    
    var viewController: UIViewController?
}
