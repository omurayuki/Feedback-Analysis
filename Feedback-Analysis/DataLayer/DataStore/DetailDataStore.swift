import Foundation
import RxSwift

protocol DetailDataStore {
    func fetch() -> Single<AccountEntity>
    func post(to documentRef: FirebaseDocumentRef, comment: Comment) -> Single<()>
}

struct DetailDataStoreImpl: DetailDataStore {
    
    func fetch() -> Single<AccountEntity> {
        return Single.create(subscribe: { single -> Disposable in
            single(.success(AccountEntity(email: AppUserDefaults.getAccountEmail(), authToken: AppUserDefaults.getAuthToken())))
            return Disposables.create()
        })
    }
    
    func post(to documentRef: FirebaseDocumentRef, comment: Comment) -> Single<()> {
        return Provider().setData(documentRef: documentRef, fields: comment.encode())
    }
}

struct DetailDataStoreFactory {
    
    static func createDetailDataStore() -> DetailDataStore {
        return DetailDataStoreImpl()
    }
}
