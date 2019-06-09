import Foundation
import RxSwift
import UIKit

protocol TopRouting: Routing {}

final class TopRoutingImpl: TopRouting {
    var viewController: UIViewController?
}
