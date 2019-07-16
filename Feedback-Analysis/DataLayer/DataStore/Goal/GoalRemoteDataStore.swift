import Foundation
import RxSwift

protocol GoalRemoteDataStore {
    func post(to documentRef: FirebaseDocumentRef, fields: GoalPost) -> Single<()>
    func update(to documentRef: FirebaseDocumentRef, fields: GoalPost) -> Single<()>
    func fetch(from queryRef: FirebaseQueryRef) -> Observable<[GoalEntity]>
    func fetch(timeline queryRef: FirebaseQueryRef) -> Observable<[GoalEntity]>
    func update(to documentRef: FirebaseDocumentRef, value: [String : Any]) -> Single<()>
    func get(documentRef: FirebaseDocumentRef) -> Single<Bool>
    func create(documentRef: FirebaseDocumentRef, value: [String: Any]) -> Single<()>
    func delete(documentRef: FirebaseDocumentRef) -> Single<()>
}

struct GoalRemoteDataStoreImpl: GoalRemoteDataStore {
    
    func post(to documentRef: FirebaseDocumentRef, fields: GoalPost) -> Single<()> {
        return Provider().setData(documentRef: documentRef, fields: fields.encode())
    }
    
    func update(to documentRef: FirebaseDocumentRef, fields: GoalPost) -> Single<()> {
        return Provider().update(documentRef: documentRef, fields: fields.encode())
    }
    
    func fetch(from queryRef: FirebaseQueryRef) -> Observable<[GoalEntity]> {
        return Provider().observeQuery(queryRef: queryRef)
    }
    
    func fetch(timeline queryRef: FirebaseQueryRef) -> Observable<[GoalEntity]> {
        return Provider().observeTimeline(queryRef: queryRef)
    }
    
    func update(to documentRef: FirebaseDocumentRef, value: [String : Any]) -> Single<()> {
        return Provider().update(documentRef: documentRef, fields: value)
    }
    
    func get(documentRef: FirebaseDocumentRef) -> Single<Bool> {
        return Provider().get(documentRef: documentRef)
    }
    
    func create(documentRef: FirebaseDocumentRef, value: [String: Any]) -> Single<()> {
        return Provider().setData(documentRef: documentRef, fields: value)
    }
    
    func delete(documentRef: FirebaseDocumentRef) -> Single<()> {
        return Provider().delete(documentRef: documentRef)
    }
}
