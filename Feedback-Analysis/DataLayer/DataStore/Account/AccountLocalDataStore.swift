import Foundation
import RxSwift

protocol AccountLocalDataStore {
    func getAuthorToken() -> Single<String>
    func getEmail() -> Single<String>
}

struct AccountLocalDataStoreImpl: AccountLocalDataStore {
    
    func getAuthorToken() -> Single<String> {
        return Single.create(subscribe: { single -> Disposable in
            single(.success(AppUserDefaults.getAuthToken()))
            return Disposables.create()
        })
    }
    
    func getEmail() -> Single<String> {
        return Single.create(subscribe: { single -> Disposable in
            single(.success(AppUserDefaults.getAccountEmail()))
            return Disposables.create()
        })
    }
}
