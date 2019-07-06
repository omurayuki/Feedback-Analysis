import Foundation
import RxSwift

protocol DetailRepository {
    func fetch() -> Single<AccountEntity>
    func post(to documentRef: FirebaseDocumentRef, comment: CommentPost) -> Single<()>
    func post(to documentRef: FirebaseDocumentRef, reply: ReplyPost) -> Single<()>
    func get(from queryRef: FirebaseQueryRef) -> Observable<[CommentEntity]>
    func get(from queryRef: FirebaseQueryRef) -> Observable<[ReplyEntity]>
    func set(document id: String) -> Single<()>
    func set(comment id: String) -> Single<()>
    func getDocumentId() -> Single<String>
    func getDocumentIds() -> Single<(documentId: String, commentId: String)>
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
    
    func post(to documentRef: FirebaseDocumentRef, reply: ReplyPost) -> Single<()> {
        let dataStore = DetailDataStoreFactory.createDetailRemoteDataStore()
        return dataStore.post(to: documentRef, reply: reply)
    }
    
    func get(from queryRef: FirebaseQueryRef) -> Observable<[CommentEntity]> {
        let dataStore = DetailDataStoreFactory.createDetailRemoteDataStore()
        return dataStore.get(from: queryRef)
    }
    
    func get(from queryRef: FirebaseQueryRef) -> Observable<[ReplyEntity]> {
        let dataStore = DetailDataStoreFactory.createDetailRemoteDataStore()
        return dataStore.get(from: queryRef)
    }
    
    func set(document id: String) -> Single<()> {
        let dataStore = DetailDataStoreFactory.createDetailLocalDataStore()
        return dataStore.set(document: id)
    }
    
    func set(comment id: String) -> Single<()> {
        let dataStore = DetailDataStoreFactory.createDetailLocalDataStore()
        return dataStore.set(comment: id)
    }
    
    func getDocumentId() -> Single<String> {
        let dataStore = DetailDataStoreFactory.createDetailLocalDataStore()
        return dataStore.getDocumentId()
    }
    
    func getDocumentIds() -> Single<(documentId: String, commentId: String)> {
        let dataStore = DetailDataStoreFactory.createDetailLocalDataStore()
        return dataStore.getDocumentIds()
    }
}
