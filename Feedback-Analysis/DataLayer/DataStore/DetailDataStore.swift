import Foundation
import RxSwift

protocol DetailDataStore {
    func fetch() -> Single<AccountEntity>
    func post(to documentRef: FirebaseDocumentRef, comment: CommentPost) -> Single<()>
    func get(from queryRef: FirebaseQueryRef) -> Observable<[CommentEntity]>
    func set(document id: String) -> Single<()>
    func getDocumentId() -> Single<String>
}

struct DetailDataStoreImpl: DetailDataStore {
    
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
    
    func set(document id: String) -> Single<()> {
        return Single.create(subscribe: { single -> Disposable in
            AppUserDefaults.setGoalDocument(id: id)
            single(.success(()))
            return Disposables.create()
        })
    }
    
    func getDocumentId() -> Single<String> {
        return Single.create(subscribe: { single -> Disposable in
            single(.success(AppUserDefaults.getGoalDocument()))
            return Disposables.create()
        })
    }
}

struct DetailDataStoreFactory {
    
    static func createDetailDataStore() -> DetailDataStore {
        return DetailDataStoreImpl()
    }
}
