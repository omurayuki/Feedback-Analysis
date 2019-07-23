import Foundation
import RxSwift

protocol FollowRepository {
    func fetchFollower(from queryRef: FirebaseQueryRef) -> Single<[UserEntity]>
    func fetchFollowee(from queryRef: FirebaseQueryRef) -> Single<[UserEntity]>
    func setFolloweeTokens(_ values: [String]) -> Single<()>
    func setFollowerTokens(_ values: [String]) -> Single<()>
    func getFolloweeToken() -> Single<[String]>
    func getFollowerToken() -> Single<[String]>
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
    
    func setFolloweeTokens(_ values: [String]) -> Single<()> {
        let dataStore = FollowDataStoreFactory.createFollowLocalDataStore()
        return dataStore.setFolloweeTokens(values)
    }
    
    func setFollowerTokens(_ values: [String]) -> Single<()> {
        let dataStore = FollowDataStoreFactory.createFollowLocalDataStore()
        return dataStore.setFollowerTokens(values)
    }
    
    func getFolloweeToken() -> Single<[String]> {
        let dataStore = FollowDataStoreFactory.createFollowLocalDataStore()
        return dataStore.getFolloweeToken()
    }
    
    func getFollowerToken() -> Single<[String]> {
        let dataStore = FollowDataStoreFactory.createFollowLocalDataStore()
        return dataStore.getFollowerToken()
    }
}
