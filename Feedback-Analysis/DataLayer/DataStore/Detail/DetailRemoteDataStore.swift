import Foundation
import RxSwift

protocol DetailRemoteDataStore {
    func fetch() -> Single<AccountEntity>
    func post(to documentRef: FirebaseDocumentRef, comment: CommentPost) -> Single<()>
    func post(to documentRef: FirebaseDocumentRef, reply: ReplyPost) -> Single<()>
    func get(from queryRef: FirebaseQueryRef) -> Observable<[CommentEntity]>
    func get(from queryRef: FirebaseQueryRef) -> Observable<[ReplyEntity]>
}

struct DetailRemoteDataStoreImpl: DetailRemoteDataStore {
    
    func fetch() -> Single<AccountEntity> {
        return Single.create(subscribe: { single -> Disposable in
            single(.success(AccountEntity(email: AppUserDefaults.getAccountEmail(), authToken: AppUserDefaults.getAuthToken())))
            return Disposables.create()
        })
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
}
