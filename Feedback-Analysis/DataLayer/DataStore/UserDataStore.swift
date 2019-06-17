import Foundation
import RxSwift

protocol UserDataStore {
    func fetch(to documentRef: FirebaseDocumentRef) -> Single<UserEntity>
    func update(to documentRef: FirebaseDocumentRef, user: Update) -> Single<()>
    func uploadImage(_ image: UIImage, at storageRef: FirebaseStorageRef) -> Single<URL>
}

struct UserDataStoreImpl: UserDataStore {
    
    func fetch(to documentRef: FirebaseDocumentRef) -> Single<UserEntity> {
        return Provider()
            .get(documentRef: documentRef)
            .map { hoge in
                UserEntity(document: hoge)
                
        }
    }
    
    func update(to documentRef: FirebaseDocumentRef, user: Update) -> Single<()> {
        return Provider().update(documentRef: documentRef, fields: user.encode())
    }
    
    func uploadImage(_ image: UIImage, at storageRef: FirebaseStorageRef) -> Single<URL> {
        return Provider().uploadImage(image, at: storageRef)
    }
}

struct UserDataStoreFactory {
    
    static func createUsserDataStore() -> UserDataStore {
        return UserDataStoreImpl()
    }
}
