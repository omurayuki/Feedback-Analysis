import Foundation
import RxSwift

protocol DetailRepository {
    func fetch() -> Single<AccountEntity>
    func update(to documentRef: FirebaseDocumentRef, value: [String : Any]) -> Single<()>
    func create(documentRef: FirebaseDocumentRef, value: [String: Any]) -> Single<()>
    func delete(documentRef: FirebaseDocumentRef) -> Single<()>
    func post(to documentRef: FirebaseDocumentRef, comment: CommentPost) -> Single<()>
    func post(to documentRef: FirebaseDocumentRef, reply: ReplyPost) -> Single<()>
    func get(from queryRef: FirebaseQueryRef) -> Observable<[CommentEntity]>
    func get(from queryRef: FirebaseQueryRef) -> Observable<[ReplyEntity]>
    func get(documentRef: FirebaseDocumentRef) -> Single<Bool>
    func set(document id: String) -> Single<()>
    func set(comment id: String) -> Single<()>
    func getDocumentId() -> Single<String>
    func getDocumentIds() -> Single<(documentId: String, commentId: String)>
    func setSelected(index: Int) -> Single<()>
    func getSelected() -> Single<Int>
    func getAuthorToken() -> Single<String>
}

struct DetailRepositoryImpl: DetailRepository {
    
    static let shared = DetailRepositoryImpl()

    func fetch() -> Single<AccountEntity> {
        let dataStore = DetailDataStoreFactory.createDetailRemoteDataStore()
        return dataStore.fetch()
    }
    
    func update(to documentRef: FirebaseDocumentRef, value: [String : Any]) -> Single<()> {
        let dataStore = DetailDataStoreFactory.createDetailRemoteDataStore()
        return dataStore.update(to: documentRef, value: value)
    }
    
    func create(documentRef: FirebaseDocumentRef, value: [String: Any]) -> Single<()> {
        let dataStore = DetailDataStoreFactory.createDetailRemoteDataStore()
        return dataStore.create(documentRef: documentRef, value: value)
    }
    
    func delete(documentRef: FirebaseDocumentRef) -> Single<()> {
        let dataStore = DetailDataStoreFactory.createDetailRemoteDataStore()
        return dataStore.delete(documentRef: documentRef)
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
    
    func get(documentRef: FirebaseDocumentRef) -> Single<Bool> {
        let dataStore = DetailDataStoreFactory.createDetailRemoteDataStore()
        return dataStore.get(documentRef: documentRef)
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
    
    func setSelected(index: Int) -> Single<()> {
        let dataStore = GoalDataStoreFactory.createGoalLocalDataStore()
        return dataStore.setSelected(index: index)
    }
    
    func getSelected() -> Single<Int> {
        let dataStore = GoalDataStoreFactory.createGoalLocalDataStore()
        return dataStore.getSelected()
    }
    
    func getAuthorToken() -> Single<String> {
        let dataStore = GoalDataStoreFactory.createGoalLocalDataStore()
        return dataStore.getAuthorToken()
    }
}
