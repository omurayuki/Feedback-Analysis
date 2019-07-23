import Foundation
import RxSwift

protocol FollowRemoteDataStore {
    func fetchFollower(from queryRef: FirebaseQueryRef) -> Single<[UserEntity]>
    func fetchFollowee(from queryRef: FirebaseQueryRef) -> Single<[UserEntity]>
}

struct FollowRemoteDataStoreImpl: FollowRemoteDataStore {
    
    let disposeBag = DisposeBag()
    
    func fetchFollower(from queryRef: FirebaseQueryRef) -> Single<[UserEntity]> {
        return Provider().getUserFollowerEntities(queryRef: queryRef)
    }
    
    func fetchFollowee(from queryRef: FirebaseQueryRef) -> Single<[UserEntity]> {
        return Provider().getUserFolloweeEntities(queryRef: queryRef)
    }
}
