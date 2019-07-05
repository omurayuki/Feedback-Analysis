import Foundation

struct UserDataStoreFactory {
    
    static func createUsserRemoteDataStore() -> UserRemoteDataStore {
        return UserRemoteDataStoreImpl()
    }
}
