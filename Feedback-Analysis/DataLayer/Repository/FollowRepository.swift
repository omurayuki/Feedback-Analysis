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
        // ここで各userの[authToken]を取得して、もう一度dataStoreにリクエストしてuserEntityを返す
        let dataStore = FollowDataStoreFactory.createFollowRemoteDataStore()
        return dataStore.dummy(from: queryRef)
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
