import Foundation

struct ConversationDataStoreFactory {
    
    static func createConversationRemoteDataStore() -> ConversationRemoteDataStore {
        return ConversationRemoteDataStoreImpl()
    }
    
    static func createConversationLocalDataStore() -> ConversationLocalDataStore {
        return ConversationLocalDataStoreImpl()
    }
}
