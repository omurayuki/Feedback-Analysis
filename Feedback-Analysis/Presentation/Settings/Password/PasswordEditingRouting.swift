import Foundation
import UIKit
import RxSwift

protocol PasswordEditingRouting: Routing {
}

final class PasswordEditingRoutingImpl: PasswordEditingRouting {
    
    var viewController: UIViewController?
}
