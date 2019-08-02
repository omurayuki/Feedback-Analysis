import Foundation
import RxSwift

protocol OtherPersonPageUseCase {
    func fetch(to: FirebaseDocumentRef) -> Single<User>
    func getAuthorToken() -> Single<String>
    func follow(documentRef: FirebaseDocumentRef) -> Single<()>
    func unFollow(documentRef: FirebaseDocumentRef) -> Single<()>
    func checkFollowing(documentRef: FirebaseDocumentRef) -> Single<Bool>
    func setObjectToken(_ token: String) -> Single<()>
    func getBothToken() -> Single<(String, String)>
    func getConversations(queryRef: FirebaseQueryRef) -> Single<[Conversation]>
    func setConversation(_ conversation: Conversation) -> Single<()>
    func getConversation() -> Single<Conversation>
}

struct OtherPersonPageUseCaseImpl: OtherPersonPageUseCase {
    
    private(set) var repository: OtherPersonPageRepository
    
    init(repository: OtherPersonPageRepository) {
        self.repository = repository
    }
    
    func fetch(to documentRef: FirebaseDocumentRef) -> Single<User> {
        return repository
            .fetch(to: documentRef)
            .map { UserTranslator().translate($0) }
    }
    
    func getAuthorToken() -> Single<String> {
        return repository.getAuthorToken()
    }
    
    func follow(documentRef: FirebaseDocumentRef) -> Single<()> {
        return repository.follow(documentRef: documentRef)
    }
    
    func unFollow(documentRef: FirebaseDocumentRef) -> Single<()> {
        return repository.unFollow(documentRef: documentRef)
    }
    
    func checkFollowing(documentRef: FirebaseDocumentRef) -> Single<Bool> {
        return repository.checkFollowing(documentRef: documentRef)
    }
    
    func setObjectToken(_ token: String) -> Single<()> {
        return repository.setObjectToken(token)
    }
    
    func getBothToken() -> Single<(String, String)> {
        return repository.getBothToken()
    }
    
    func getConversations(queryRef: FirebaseQueryRef) -> Single<[Conversation]> {
        return repository.getConversations(queryRef: queryRef).map { ConversationsTranslator().translate($0) }
    }
    
    func setConversation(_ conversation: Conversation) -> Single<()> {
        return repository.setConversation(conversation)
    }
    
    func getConversation() -> Single<Conversation> {
        return repository.getConversation()
    }
}
