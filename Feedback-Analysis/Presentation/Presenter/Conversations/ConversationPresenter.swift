import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol ConversationPresenter: Presenter {
    
    var view: ConversationPresenterView! { get set }
    
    func fetchConversations(queryRef: FirebaseQueryRef)
    func markAsRead(conversation: Conversation, completion: @escaping () -> Void)
}

protocol ConversationPresenterView: class {
    var disposeBag: DisposeBag! { get }
    
    func inject(ui: ConversationUI,
                presenter: ConversationPresenter,
                routing: ConversationRouting,
                disposeBag: DisposeBag)
    
    func didFetch(conversation: [Conversation])
    func didSelect(indexPath: IndexPath, tableView: UITableView)
    func showError(message: String)
}
