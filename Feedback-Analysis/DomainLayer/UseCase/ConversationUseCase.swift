import Foundation
import RxSwift

protocol ConversationUseCase {
    func fetchConversations(from queryRef: FirebaseQueryRef) -> Observable<[Conversation]>
    func markAsRead(conversation: Conversation) -> Single<()>
}

struct ConversationUseCaseImpl: ConversationUseCase {
    
    private(set) var repository: ConversationRepository
    
    init(repository: ConversationRepository) {
        self.repository = repository
    }
    
    func fetchConversations(from queryRef: FirebaseQueryRef) -> Observable<[Conversation]> {
        return repository.fetchConversations(from: queryRef).map { ConversationsTranslator().translate($0) }
    }
    
    func markAsRead(conversation: Conversation) -> Single<()> {
        return repository.markAsRead(conversation: conversation)
    }
}
