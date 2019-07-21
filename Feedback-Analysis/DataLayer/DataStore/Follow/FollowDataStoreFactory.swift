import Foundation

struct FollowDataStoreFactory {
    
    static func createFollowRemoteDataStore() -> FollowRemoteDataStore {
        return FollowRemoteDataStoreImpl()
    }
    
    static func createFollowLocalDataStore() -> FollowLocalDataStore {
        return FollowLocalDataStoreImpl()
    }
}
