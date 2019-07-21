import Foundation
import RxSwift

protocol FollowRemoteDataStore {
    func fetch(from queryRef: FirebaseQueryRef) -> Observable<[UserEntity]>
}

struct FollowRemoteDataStoreImpl: FollowRemoteDataStore {
    
    func fetch(from queryRef: FirebaseQueryRef) -> Observable<[UserEntity]> {
        return Observable.create({ observer -> Disposable in
            observer.on(.next([UserEntity(document: ["user_token": "ff", "header_image": "ss", "user_image": "dd", "name": "hoge", "content": "ssssssssssssssssssss", "residence": "ss", "birth": "ss", "follow": 1, "follower": 1]),
                               UserEntity(document: ["user_token": "ff", "header_image": "ss", "user_image": "dd", "name": "hoge", "content": "ssssssssssssssssssss", "residence": "ss", "birth": "ss", "follow": 1, "follower": 1]),
                               UserEntity(document: ["user_token": "ff", "header_image": "ss", "user_image": "dd", "name": "hoge", "content": "ssssssssssssssssssss", "residence": "ss", "birth": "ss", "follow": 1, "follower": 1]),
                               UserEntity(document: ["user_token": "ff", "header_image": "ss", "user_image": "dd", "name": "hoge", "content": "ssssssssssssssssssss", "residence": "ss", "birth": "ss", "follow": 1, "follower": 1]),
                UserEntity(document: ["user_token": "ff", "header_image": "ss", "user_image": "dd", "name": "hoge", "content": "ssssssssssssssssssss", "residence": "ss", "birth": "ss", "follow": 1, "follower": 1]),
                UserEntity(document: ["name": "pppp"])
                ]))
            return Disposables.create()
        })
    }
}
