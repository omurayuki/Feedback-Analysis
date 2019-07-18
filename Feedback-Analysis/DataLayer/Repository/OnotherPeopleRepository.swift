import Foundation
import RxSwift

protocol OnotherPeopleRepository {
    func fetch(to documentRef: FirebaseDocumentRef) -> Single<UserEntity>
    func getAuthorToken() -> Single<String>
}

struct OnotherPeopleRepositoryImpl: OnotherPeopleRepository {
    
    static let shared = OnotherPeopleRepositoryImpl()
    
    func fetch(to documentRef: FirebaseDocumentRef) -> Single<UserEntity> {
        let dataStore = UserDataStoreFactory.createUserRemoteDataStore()
        return dataStore.fetch(to: documentRef)
    }
    
    func getAuthorToken() -> Single<String> {
        let dataStore = UserDataStoreFactory.createUserLocalDataStore()
        return dataStore.getAuthorToken()
    }
}
