import Foundation
import RxSwift

protocol FollowRemoteDataStore {
    func fetchFollower(from queryRef: FirebaseQueryRef) -> Single<[UserEntity]>
    func fetchFollowee(from queryRef: FirebaseQueryRef) -> Single<[UserEntity]>
}

struct FollowRemoteDataStoreImpl: FollowRemoteDataStore {
    
    func fetchFollower(from queryRef: FirebaseQueryRef) -> Single<[UserEntity]> {
        return Single.create(subscribe: { single -> Disposable in
            UserEntityManager().fetchUserFollowerEntities(queryRef: queryRef, completion: { response in
                switch response {
                case .success(let entities):
                    single(.success(entities))
                case .failure(let error):
                    single(.error(FirebaseError.resultError(error)))
                case .unknown:
                    single(.error(FirebaseError.unknown))
                }
            })
            return Disposables.create()
        })
    }
    
    func fetchFollowee(from queryRef: FirebaseQueryRef) -> Single<[UserEntity]> {
        return Single.create(subscribe: { single -> Disposable in
            UserEntityManager().fetchUserFolloweeEntities(queryRef: queryRef, completion: { response in
                switch response {
                case .success(let entities):
                    single(.success(entities))
                case .failure(let error):
                    single(.error(FirebaseError.resultError(error)))
                case .unknown:
                    single(.error(FirebaseError.unknown))
                }
            })
            return Disposables.create()
        })
    }
}
