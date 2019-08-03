import Foundation
import UIKit
import RxSwift

protocol ConversationRouting: Routing {
    func showMessagePage()
}

final class ConversationRoutingImpl: ConversationRouting {
    
    var viewController: UIViewController?
    
    func showMessagePage() {
        print("message")
    }
}
