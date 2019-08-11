import Foundation
import UIKit
import RxSwift

protocol TimelineRouting: Routing {}

final class TimelineRoutingImpl: TimelineRouting {
    
    var viewController: UIViewController?
}
