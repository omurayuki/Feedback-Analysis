import Foundation
import RxSwift

protocol FollowRepository {
    func fetch(from queryRef: FirebaseQueryRef) -> Observable<[UserEntity]>
    func setAuthorTokens(_ values: [String]) -> Single<()>
    func getAuthorToken(_ index: Int) -> Single<String>
}

struct FollowRepositoryImpl: FollowRepository {
    
    static let shared = FollowRepositoryImpl()
    
    func fetch(from queryRef: FirebaseQueryRef) -> Observable<[UserEntity]> {
        let dataStore = FollowDataStoreFactory.createFollowRemoteDataStore()
        return dataStore.fetch(from: queryRef)
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
