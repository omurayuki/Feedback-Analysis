import Foundation
import RxSwift
import RxCocoa

class MessagesPresenterImpl: NSObject, MessagesPresenter {
    
    var disposeBag: DisposeBag = DisposeBag()
    
    var conversation: Conversation!
    
    var subjectToken: String!
    
    var view: MessagesPresenterView!
    
    private var useCase: ConversationUseCase
    
    init(useCase: ConversationUseCase) {
        self.useCase = useCase
    }
    
    func setup() {}
    
    func fetchMessages(queryRef: FirebaseQueryRef) {
        useCase.fetchMessages(queryRef: queryRef)
            .subscribe(onNext: { [unowned self] entities in
                self.view.didFetchMessages(messages: entities)
            }, onError: { [unowned self] error in
                self.view.showError(message: error.localizedDescription)
            }).disposed(by: disposeBag)
    }
    
    func getAuthToken(completion: @escaping (String) -> Void) {
        useCase.getAuthToken()
            .subscribe { result in
                switch result {
                case .success(let response):
                    completion(response)
                case .error(_):
                    return
                }
            }.disposed(by: disposeBag)
    }
}
