import Foundation
import UIKit
import RxSwift

protocol ConversationRouting: Routing {
    func showMessagePage(conversation: Conversation)
}

final class ConversationRoutingImpl: ConversationRouting {
    
    var viewController: UIViewController?
    
    func showMessagePage(conversation: Conversation) {
        let sb = UIStoryboard(name: "Messages", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: "MessagesViewController") as? MessagesViewController else { return }
        vc.inject(conversation: conversation)
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
