import Foundation
import RxSwift

protocol FollowRepository {
    func fetchFollower(from queryRef: FirebaseQueryRef) -> Single<[UserEntity]>
    func fetchFollowee(from queryRef: FirebaseQueryRef) -> Single<[UserEntity]>
    func setAuthorTokens(_ values: [String]) -> Single<()>
    func getAuthorToken(_ index: Int) -> Single<String>
}

struct FollowRepositoryImpl: FollowRepository {
    
    static let shared = FollowRepositoryImpl()
    
    func fetchFollower(from queryRef: FirebaseQueryRef) -> Single<[UserEntity]> {
        let dataStore = FollowDataStoreFactory.createFollowRemoteDataStore()
        return dataStore.fetchFollower(from: queryRef)
    }
    
    func fetchFollowee(from queryRef: FirebaseQueryRef) -> Single<[UserEntity]> {
        let dataStore = FollowDataStoreFactory.createFollowRemoteDataStore()
        return dataStore.fetchFollowee(from: queryRef)
    }
    
    func setAuthorTokens(_ values: [String]) -> Single<()> {
        let dataStore = FollowDataStoreFactory.createFollowLocalDataStore()
        return dataStore.setAuthorTokens(values)
    }
    
    func getAuthorToken(_ index: Int) -> Single<String> {
        let dataStore = FollowDataStoreFactory.createFollowLocalDataStore()
        return dataStore.getAuthorToken(index)
    }
}
