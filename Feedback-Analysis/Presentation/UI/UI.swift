import Foundation
import UIKit

protocol UI {
    var viewController: UIViewController? { get set }
}

extension UI {
    static func create<T>(_ setup: ((T) -> Void)) -> T where T: NSObject {
        let obj = T()
        setup(obj)
        return obj
    }
}

protocol PublicTimelineContentUI: UI {
    var refControl: UIRefreshControl { get }
    var timeline: UITableView { get set }
    func setup()
}

protocol PrivateTimelineContentUI: UI {
    var timeline: UITableView { get set }
    func setup()
}
