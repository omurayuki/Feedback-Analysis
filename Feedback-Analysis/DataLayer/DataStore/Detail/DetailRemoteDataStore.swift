import Foundation
import RxSwift

protocol DetailRemoteDataStore {
    func fetch() -> Single<AccountEntity>
    func post(to documentRef: FirebaseDocumentRef, comment: CommentPost) -> Single<()>
    func get(from queryRef: FirebaseQueryRef) -> Observable<[CommentEntity]>
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
    
    func get(from queryRef: FirebaseQueryRef) -> Observable<[CommentEntity]> {
        return Provider().observeQuery(queryRef: queryRef)
    }
}
