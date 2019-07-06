import Foundation
import RxSwift

protocol DetailRemoteDataStore {
    func fetch() -> Single<AccountEntity>
    func update(to documentRef: FirebaseDocumentRef, value: [String : Any]) -> Single<()>
    func create(documentRef: FirebaseDocumentRef, value: [String: Any]) -> Single<()>
    func delete(documentRef: FirebaseDocumentRef) -> Single<()>
    func post(to documentRef: FirebaseDocumentRef, comment: CommentPost) -> Single<()>
    func post(to documentRef: FirebaseDocumentRef, reply: ReplyPost) -> Single<()>
    func get(from queryRef: FirebaseQueryRef) -> Observable<[CommentEntity]>
    func get(from queryRef: FirebaseQueryRef) -> Observable<[ReplyEntity]>
    func get(documentRef: FirebaseDocumentRef) -> Single<Bool>
}

struct DetailRemoteDataStoreImpl: DetailRemoteDataStore {
    
    func fetch() -> Single<AccountEntity> {
        return Single.create(subscribe: { single -> Disposable in
            single(.success(AccountEntity(email: AppUserDefaults.getAccountEmail(), authToken: AppUserDefaults.getAuthToken())))
            return Disposables.create()
        })
    }
    
    func update(to documentRef: FirebaseDocumentRef, value: [String : Any]) -> Single<()> {
        return Provider().update(documentRef: documentRef, fields: value)
    }
    
    func create(documentRef: FirebaseDocumentRef, value: [String: Any]) -> Single<()> {
        return Provider().setData(documentRef: documentRef, fields: value)
    }
    
    func delete(documentRef: FirebaseDocumentRef) -> Single<()> {
        return Provider().delete(documentRef: documentRef)
    }
    
    func post(to documentRef: FirebaseDocumentRef, comment: CommentPost) -> Single<()> {
        return Provider().setData(documentRef: documentRef, fields: comment.encode())
    }
    
    func post(to documentRef: FirebaseDocumentRef, reply: ReplyPost) -> Single<()> {
        return Provider().setData(documentRef: documentRef, fields: reply.encode())
    }
    
    func get(from queryRef: FirebaseQueryRef) -> Observable<[CommentEntity]> {
        return Provider().observeQuery(queryRef: queryRef)
    }
    
    func get(from queryRef: FirebaseQueryRef) -> Observable<[ReplyEntity]> {
        return Provider().observeQuery(queryRef: queryRef)
    }
    
    func get(documentRef: FirebaseDocumentRef) -> Single<Bool> {
        return Provider().get(documentRef: documentRef)
    }
}
