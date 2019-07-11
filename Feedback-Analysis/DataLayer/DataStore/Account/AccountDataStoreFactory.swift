import Foundation

struct AccountDataStoreFactory {
    
    static func createAccountRemoteDataStore() -> AccountRemoteDataStore {
        return AccountRemoteDataStoreImpl()
    }
    
    static func createAccountLocalDataStore() -> AccountLocalDataStore {
        return AccountLocalDataStoreImpl()
    }
}
