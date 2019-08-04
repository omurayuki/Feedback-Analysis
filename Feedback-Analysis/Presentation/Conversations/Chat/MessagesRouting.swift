import Foundation
import RxSwift

protocol MessagesRouting: Routing {
    
}

class MessagesRoutingImpl: MessagesRouting {
    
    var viewController: UIViewController?
}
