import Foundation
import RxSwift

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
        return Provider()
            .get(documentRef: documentRef)
            .map { UserEntity(document: $0) }
    }
    
    func update(to documentRef: FirebaseDocumentRef, user: Update) -> Single<()> {
        return Provider().update(documentRef: documentRef, fields: user.encode())
    }
    
    func uploadImage(_ image: UIImage, at storageRef: FirebaseStorageRef) -> Single<URL> {
        return Provider().uploadImage(image, at: storageRef)
    }
    
    func follow(documentRef: FirebaseDocumentRef) -> Single<()> {
        return Provider().setData(documentRef: documentRef,
                                  fields: ["following_user_token": AppUserDefaults.getAuthToken()])
    }
    
    func unFollow(documentRef: FirebaseDocumentRef) -> Single<()> {
        return Provider().delete(documentRef: documentRef)
    }
    
    func checkFollowing(documentRef: FirebaseDocumentRef) -> Single<Bool> {
        return Provider().get(documentRef: documentRef)
    }
}
