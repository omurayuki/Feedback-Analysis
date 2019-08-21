import Foundation
import UIKit
import RxSwift

protocol CategorizedRouting: Routing {
    func showDetail()
}

final class CategorizedRoutingImpl: CategorizedRouting {
    
    var viewController: UIViewController?
    
    func showDetail() {
        print("")
    }
}
