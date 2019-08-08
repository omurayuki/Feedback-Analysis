import Foundation
import UIKit
import RxSwift

protocol ConversationRouting: Routing {
    func showMessagePage(conversation: Conversation)
}

final class ConversationRoutingImpl: ConversationRouting {
    
    var viewController: UIViewController?
    
    func showMessagePage(conversation: Conversation) {
        let repository = ConversationRepositoryImpl.shared
        let useCase = ConversationUseCaseImpl(repository: repository)
        let presenter = MessagesPresenterImpl(useCase: useCase)
        let routing = MessagesRoutingImpl()
        let sb = UIStoryboard(name: "Messages", bundle: nil)
        if let vc = sb.instantiateViewController(withIdentifier: "MessagesViewController") as? MessagesViewController {
            routing.viewController = vc
            let _ = vc.view
            vc.inject(presenter: presenter, routing: routing)
            vc.recieve(conversation: conversation)
            viewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
