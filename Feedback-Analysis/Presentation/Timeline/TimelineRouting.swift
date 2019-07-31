import Foundation
import UIKit
import RxSwift

protocol TimelineRouting: Routing {
    func showSearchPage()
}

final class TimelineRoutingImpl: TimelineRouting {
    
    var viewController: UIViewController?
    
    func showSearchPage() {
        print("search")
    }
}
