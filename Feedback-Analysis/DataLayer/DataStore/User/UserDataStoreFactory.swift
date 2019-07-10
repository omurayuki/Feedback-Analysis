import Foundation

struct UserDataStoreFactory {
    
    static func createUserRemoteDataStore() -> UserRemoteDataStore {
        return UserRemoteDataStoreImpl()
    }
    
    static func createUserLocalDataStore() -> UserLocalDataStore {
        return UserLocalDataStoreImpl()
    }
}
