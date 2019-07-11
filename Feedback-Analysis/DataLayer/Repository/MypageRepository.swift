import Foundation
import RxSwift

protocol MypageRepository {
    func fetch(to documentRef: FirebaseDocumentRef) -> Single<UserEntity>
    func update(to documentRef: FirebaseDocumentRef, user: Update) -> Single<()>
    func uploadImage(_ image: UIImage, at storageRef: FirebaseStorageRef) -> Single<URL>
    func set(user: [User]) -> Single<()>
    func getUser() -> Single<[UserEntity]>
    func getAuthorToken() -> Single<String>
}

struct MypageRepositoryImpl: MypageRepository {
    
    static let shared = MypageRepositoryImpl()
    
    func fetch(to documentRef: FirebaseDocumentRef) -> Single<UserEntity> {
        let dataStore = UserDataStoreFactory.createUserRemoteDataStore()
        return dataStore.fetch(to: documentRef)
    }
    
    func update(to documentRef: FirebaseDocumentRef, user: Update) -> Single<()> {
        let dataStore = UserDataStoreFactory.createUserRemoteDataStore()
        return dataStore.update(to: documentRef, user: user)
    }
    
    func uploadImage(_ image: UIImage, at storageRef: FirebaseStorageRef) -> Single<URL> {
        let dataStore = UserDataStoreFactory.createUserRemoteDataStore()
        return dataStore.uploadImage(image, at: storageRef)
    }
    
    func set(user: [User]) -> Single<()> {
        let dataStore = UserDataStoreFactory.createUserLocalDataStore()
        return dataStore.set(user: user)
    }
    
    func getUser() -> Single<[UserEntity]> {
        let dataStore = UserDataStoreFactory.createUserLocalDataStore()
        return dataStore.getUser()
    }
    
    func getAuthorToken() -> Single<String> {
        let dataStore = UserDataStoreFactory.createUserLocalDataStore()
        return dataStore.getAuthorToken()
    }
}
