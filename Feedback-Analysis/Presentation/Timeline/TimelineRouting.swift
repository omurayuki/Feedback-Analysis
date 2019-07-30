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
//        let sb = UIStoryboard(name: "Messages", bundle: nil)
//        let vc = sb.instantiateViewController(withIdentifier: "MessagesViewController")
//        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
