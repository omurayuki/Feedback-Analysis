import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol MessagesPresenter: Presenter {
    
    var disposeBag: DisposeBag { get }
    var conversation: Conversation! { get set }
    var subjectToken: String! { get set }
    var view: MessagesPresenterView! { get set }
    
    func fetchMessages(queryRef: FirebaseQueryRef)
    func getAuthToken(completion: @escaping (String) -> Void)
}

protocol MessagesPresenterView: class {
    
    func inject(presenter: MessagesPresenter,
                routing: MessagesRouting)
    func didFetchMessages(messages: [Message])
    func showError(message: String)
}
