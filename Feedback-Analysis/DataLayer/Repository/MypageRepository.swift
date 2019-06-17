import Foundation
import RxSwift

protocol MypageRepository {
    func fetch(to documentRef: FirebaseDocumentRef) -> Single<UserEntity>
    func update(to documentRef: FirebaseDocumentRef, user: Update) -> Single<()>
    func uploadImage(_ image: UIImage, at storageRef: FirebaseStorageRef) -> Single<URL>
}

struct MypageRepositoryImpl: MypageRepository {
    
    static let shared = MypageRepositoryImpl()
    
    private let dataStore = UserDataStoreFactory.createUsserDataStore()
    
    func fetch(to documentRef: FirebaseDocumentRef) -> Single<UserEntity> {
        return dataStore.fetch(to: documentRef)
    }
    
    func update(to documentRef: FirebaseDocumentRef, user: Update) -> Single<()> {
        return dataStore.update(to: documentRef, user: user)
    }
    
    func uploadImage(_ image: UIImage, at storageRef: FirebaseStorageRef) -> Single<URL> {
        return dataStore.uploadImage(image, at: storageRef)
    }
}
