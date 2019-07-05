import Foundation
import RxSwift

protocol DetailRepository {
    func fetch() -> Single<AccountEntity>
    func post(to documentRef: FirebaseDocumentRef, comment: CommentPost) -> Single<()>
    func get(from queryRef: FirebaseQueryRef) -> Observable<[CommentEntity]>
    func set(document id: String) -> Single<()>
    func getDocumentId() -> Single<String>
}

struct DetailRepositoryImpl: DetailRepository {
    
    static let shared = DetailRepositoryImpl()

    func fetch() -> Single<AccountEntity> {
        let dataStore = DetailDataStoreFactory.createDetailRemoteDataStore()
        return dataStore.fetch()
    }
    
    func post(to documentRef: FirebaseDocumentRef, comment: CommentPost) -> Single<()> {
        let dataStore = DetailDataStoreFactory.createDetailRemoteDataStore()
        return dataStore.post(to: documentRef, comment: comment)
    }
    
    func get(from queryRef: FirebaseQueryRef) -> Observable<[CommentEntity]> {
        let dataStore = DetailDataStoreFactory.createDetailRemoteDataStore()
        return dataStore.get(from: queryRef)
    }
    
    func set(document id: String) -> Single<()> {
        let dataStore = DetailDataStoreFactory.createDetailLocalDataStore()
        return dataStore.set(document: id)
    }
    
    func getDocumentId() -> Single<String> {
        let dataStore = DetailDataStoreFactory.createDetailLocalDataStore()
        return dataStore.getDocumentId()
    }
}
