import Foundation
import RxSwift

protocol FollowRepository {
    func fetchFollower(from queryRef: FirebaseQueryRef) -> Single<[UserEntity]>
    func fetchFollowee(from queryRef: FirebaseQueryRef) -> Single<[UserEntity]>
    func getAuthorToken() -> Single<String>
    func setFolloweeTokens(_ values: [String]) -> Single<()>
    func setFollowerTokens(_ values: [String]) -> Single<()>
    func getFolloweeToken() -> Single<[String]>
    func getFollowerToken() -> Single<[String]>
    func setObjectToken(_ value: String) -> Single<()>
    func getObjectToken() -> Single<String>
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
    
    func getAuthorToken() -> Single<String> {
        let dataStore = FollowDataStoreFactory.createFollowLocalDataStore()
        return dataStore.getAuthorToken()
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
    
    func setObjectToken(_ value: String) -> Single<()> {
        let dataStore = FollowDataStoreFactory.createFollowLocalDataStore()
        return dataStore.setObjectToken(value)
    }
    
    func getObjectToken() -> Single<String> {
        let dataStore = FollowDataStoreFactory.createFollowLocalDataStore()
        return dataStore.getObjectToken()
    }
}
