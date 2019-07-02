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
    
    private let dataStore = DetailDataStoreFactory.createDetailDataStore()
    
    func fetch() -> Single<AccountEntity> {
        return dataStore.fetch()
    }
    
    func post(to documentRef: FirebaseDocumentRef, comment: CommentPost) -> Single<()> {
        return dataStore.post(to: documentRef, comment: comment)
    }
    
    func get(from queryRef: FirebaseQueryRef) -> Observable<[CommentEntity]> {
        return dataStore.get(from: queryRef)
    }
    
    func set(document id: String) -> Single<()> {
        return dataStore.set(document: id)
    }
    
    func getDocumentId() -> Single<String> {
        return dataStore.getDocumentId()
    }
}
