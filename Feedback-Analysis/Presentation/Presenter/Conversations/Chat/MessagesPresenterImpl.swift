import Foundation
import RxSwift
import RxCocoa

class MessagesPresenterImpl: NSObject, MessagesPresenter {
    
    var disposeBag: DisposeBag = DisposeBag()
    
    var conversation: Conversation!
    
    var view: MessagesPresenterView!
    
    private var useCase: ConversationUseCase
    
    init(useCase: ConversationUseCase) {
        self.useCase = useCase
    }
    
    func setup() {}
}
