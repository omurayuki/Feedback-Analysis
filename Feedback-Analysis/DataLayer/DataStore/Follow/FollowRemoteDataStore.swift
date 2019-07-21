import Foundation
import RxSwift

protocol FollowRemoteDataStore {
    func fetch(from queryRef: FirebaseQueryRef) -> Observable<[UserEntity]>
}

struct FollowRemoteDataStoreImpl: FollowRemoteDataStore {
    
    func fetch(from queryRef: FirebaseQueryRef) -> Observable<[UserEntity]> {
        return Observable.create({ observer -> Disposable in
            
            return Disposables.create()
        })
    }
}
