import Foundation
import RxSwift
import RxCocoa

class ConversationPresenterImpl: NSObject, ConversationPresenter {
    
    var view: ConversationPresenterView!
    
    private var useCase: ConversationUseCase
    
    init(useCase: ConversationUseCase) {
        self.useCase = useCase
    }
    
    func fetchConversations(queryRef: FirebaseQueryRef) {
        useCase.fetchConversations(from: queryRef)
            .subscribe(onNext: { [unowned self] entities in
                self.view.didFetch(conversation: entities)
            }, onError: { [unowned self] error in
                self.view.showError(message: error.localizedDescription)
            }).disposed(by: view.disposeBag)
    }
    
    func markAsRead(conversation: Conversation, completion: @escaping () -> Void) {
        useCase.markAsRead(conversation: conversation)
            .subscribe { result in
                switch result {
                case .success(_):
                    completion()
                case .error(let error):
                    self.view.showError(message: error.localizedDescription)
                }
            }.disposed(by: view.disposeBag)
    }
    
    func setup() {}
}

extension ConversationPresenterImpl: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.didSelect(indexPath: indexPath, tableView: tableView)
    }
}
