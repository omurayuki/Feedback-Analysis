import Foundation
import UIKit
import RxSwift

protocol EmailEditingRouting: Routing {
}

final class EmailEditingRoutingImpl: EmailEditingRouting {
    
    var viewController: UIViewController?
}
