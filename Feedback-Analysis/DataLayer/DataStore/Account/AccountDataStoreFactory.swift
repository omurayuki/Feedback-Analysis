import Foundation

struct AccountDataStoreFactory {
    
    static func createAccountRemoteDataStore() -> AccountRemoteDataStore {
        return AccountRemoteDataStoreImpl()
    }
}
