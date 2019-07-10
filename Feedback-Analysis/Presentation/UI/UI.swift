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

protocol TimelineContentUI: UI {
    var timeline: UITableView { get set }
    func setup()
}
