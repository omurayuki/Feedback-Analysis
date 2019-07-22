import Foundation
import RxSwift

protocol FollowRemoteDataStore {
    func fetch(from queryRef: FirebaseQueryRef)
    func dummy(from queryRef: FirebaseQueryRef) -> Observable<[UserEntity]>
}

struct FollowRemoteDataStoreImpl: FollowRemoteDataStore {
    
    func fetch(from queryRef: FirebaseQueryRef) {
        FirebaseQueryRef
            .followerRefFromOtherPerson
            .destination.getDocuments(completion: { snapshot, error in
            if let error = error {
                return
            }
            guard let snapshots = snapshot?.documents else {
                return
            }
            snapshots.forEach {
                print("wwwwwwwwwwwwww")
                print($0.data()["following_user_token"])
            }
        })
    }

    
    func dummy(from queryRef: FirebaseQueryRef) -> Observable<[UserEntity]> {
        return Observable.create({ observer -> Disposable in
            observer.on(.next(
                [UserEntity(document: ["user_token": "ff", "header_image": "ss", "user_image": "dd", "name": "hoge", "content": "ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss", "residence": "ss", "birth": "ss", "follow": 1, "follower": 1]),
                 UserEntity(document: ["user_token": "ff", "header_image": "ss", "user_image": "dd", "name": "hoge", "content": "ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss", "residence": "ss", "birth": "ss", "follow": 1, "follower": 1]),
                 UserEntity(document: ["user_token": "ff", "header_image": "ss", "user_image": "dd", "name": "hoge", "content": "ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss", "residence": "ss", "birth": "ss", "follow": 1, "follower": 1]),
                 UserEntity(document: ["user_token": "ff", "header_image": "ss", "user_image": "dd", "name": "hoge", "content": "ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss", "residence": "ss", "birth": "ss", "follow": 1, "follower": 1]),
                 UserEntity(document: ["user_token": "ff", "header_image": "ss", "user_image": "dd", "name": "hoge", "content": "ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss", "residence": "ss", "birth": "ss", "follow": 1, "follower": 1])
                ]))
            return Disposables.create()
        })
    }
}
