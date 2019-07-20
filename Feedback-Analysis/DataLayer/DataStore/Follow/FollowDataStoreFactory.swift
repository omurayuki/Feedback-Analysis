import Foundation

struct FollowDataStoreFactory {
    
    static func createFollowRemoteDataStore() -> FollowRemoteDataStore {
        return FollowRemoteDataStoreImpl()
    }
    
    static func createFollowRemoteDataStore() -> FollowLocalDataStore {
        return FollowLocalDataStoreImpl()
    }
}
