import Foundation
import RxSwift

protocol ConversationRepository {
    func fetchConversations(from queryRef: FirebaseQueryRef) -> Observable<[ConversationEntity]>
    func markAsRead(conversation: Conversation) -> Single<()>
}

struct ConversationRepositoryImpl: ConversationRepository {
    
    static let shared = ConversationRepositoryImpl()
    
    func fetchConversations(from queryRef: FirebaseQueryRef) -> Observable<[ConversationEntity]> {
        let dataStore = ConversationDataStoreFactory.createConversationRemoteDataStore()
        return dataStore.fetchConversations(from: queryRef)
    }
    
    func markAsRead(conversation: Conversation) -> Single<()> {
        let dataStore = ConversationDataStoreFactory.createConversationRemoteDataStore()
        return dataStore.markAsRead(conversation: conversation)
    }
}
