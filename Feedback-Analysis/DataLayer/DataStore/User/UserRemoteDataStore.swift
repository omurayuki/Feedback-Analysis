import Foundation
import RxSwift
import FirebaseFirestore

protocol UserRemoteDataStore {
    func fetch(to documentRef: FirebaseDocumentRef) -> Single<UserEntity>
    func update(to documentRef: FirebaseDocumentRef, user: Update) -> Single<()>
    func uploadImage(_ image: UIImage, at storageRef: FirebaseStorageRef) -> Single<URL>
    func follow(documentRef: FirebaseDocumentRef) -> Single<()>
    func unFollow(documentRef: FirebaseDocumentRef) -> Single<()>
    func checkFollowing(documentRef: FirebaseDocumentRef) -> Single<Bool>
}

struct UserRemoteDataStoreImpl: UserRemoteDataStore {
    
    func fetch(to documentRef: FirebaseDocumentRef) -> Single<UserEntity> {
        return Single.create(subscribe: { single -> Disposable in
            UserEntityManager().fetchUserEntity(documentRef: documentRef) { response in
                switch response {
                case .success(let entity):
                    single(.success(entity))
                case .failure(let error):
                    single(.error(FirebaseError.resultError(error)))
                case .unknown:
                    single(.error(FirebaseError.unknown))
                }
            }
            return Disposables.create()
        })
    }
    
    func update(to documentRef: FirebaseDocumentRef, user: Update) -> Single<()> {
        return Single.create(subscribe: { single -> Disposable in
            Provider().update(documentRef: documentRef, fields: user.encode(),
                               completion: { response in
                switch response {
                case .success(_):
                    single(.success(()))
                case .failure(let error):
                    single(.error(FirebaseError.resultError(error)))
                case .unknown:
                    single(.error(FirebaseError.unknown))
                }
            })
            return Disposables.create()
        })
    }
    
    func uploadImage(_ image: UIImage, at storageRef: FirebaseStorageRef) -> Single<URL> {
        return Single.create(subscribe: { single -> Disposable in
            AccountEntityManager().uploadImage(image, at: storageRef, completion: { response in
                switch response {
                case .success(let entity):
                    single(.success(entity))
                case .failure(let error):
                    single(.error(FirebaseError.resultError(error)))
                case .unknown:
                    single(.error(FirebaseError.unknown))
                }
            })
            return Disposables.create()
        })
    }
    
    func follow(documentRef: FirebaseDocumentRef) -> Single<()> {
        return Single.create(subscribe: { single -> Disposable in
            Provider().setData(documentRef: documentRef, fields: ["following_user_token": AppUserDefaults.getAuthToken(),
                                                                  "follower_user_token": AppUserDefaults.getObjectToken(),
                                                                  "created_at": FieldValue.serverTimestamp()],
                               completion: { response in
                switch response {
                case .success(_):
                    single(.success(()))
                case .failure(let error):
                    single(.error(FirebaseError.resultError(error)))
                case .unknown:
                    single(.error(FirebaseError.unknown))
                }
            })
            return Disposables.create()
        })
    }
    
    func unFollow(documentRef: FirebaseDocumentRef) -> Single<()> {
        return Single.create(subscribe: { single -> Disposable in
            Provider().delete(documentRef: documentRef, completion: { response in
                switch response {
                case .success(_):
                    single(.success(()))
                case .failure(let error):
                    single(.error(FirebaseError.resultError(error)))
                case .unknown:
                    single(.error(FirebaseError.unknown))
                }
            })
            return Disposables.create()
        })
    }
    
    func checkFollowing(documentRef: FirebaseDocumentRef) -> Single<Bool> {
        return Single.create(subscribe: { single -> Disposable in
            Provider().isExists(documentRef: documentRef, completion: { response in
                switch response {
                case .success(let entity):
                    single(.success(entity))
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
