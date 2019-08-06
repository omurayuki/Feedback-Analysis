import Foundation
import RxSwift

protocol ConversationRepository {
    func fetchConversations(from queryRef: FirebaseQueryRef) -> Observable<[ConversationEntity]>
    func markAsRead(conversation: Conversation) -> Single<()>
    func fetchMessages(queryRef: FirebaseQueryRef) -> Observable<[MessageEntity]>
    func getAuthToken() -> Single<String>
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
    
    func fetchMessages(queryRef: FirebaseQueryRef) -> Observable<[MessageEntity]> {
        let dataStore = ConversationDataStoreFactory.createConversationRemoteDataStore()
        return dataStore.fetchMessages(queryRef: queryRef)
    }
    
    func getAuthToken() -> Single<String> {
        let dataStore = ConversationDataStoreFactory.createConversationLocalDataStore()
        return dataStore.getAuthToken()
    }
}
