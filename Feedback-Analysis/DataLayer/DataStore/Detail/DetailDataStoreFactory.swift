import Foundation

struct DetailDataStoreFactory {
    
    static func createDetailRemoteDataStore() -> DetailRemoteDataStore {
        return DetailRemoteDataStoreImpl()
    }
    
    static func createDetailLocalDataStore() -> DetailLocalDataStore {
        return DetailLocalDataStoreImpl()
    }
}
