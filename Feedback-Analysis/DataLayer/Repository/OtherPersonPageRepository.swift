import Foundation
import RxSwift

protocol OtherPersonPageRepository {
    func fetch(to documentRef: FirebaseDocumentRef) -> Single<UserEntity>
    func getAuthorToken() -> Single<String>
}

struct OtherPersonPageRepositoryImpl: OtherPersonPageRepository {
    
    static let shared = OtherPersonPageRepositoryImpl()
    
    func fetch(to documentRef: FirebaseDocumentRef) -> Single<UserEntity> {
        let dataStore = UserDataStoreFactory.createUserRemoteDataStore()
        return dataStore.fetch(to: documentRef)
    }
    
    func getAuthorToken() -> Single<String> {
        let dataStore = UserDataStoreFactory.createUserLocalDataStore()
        return dataStore.getAuthorToken()
    }
}
