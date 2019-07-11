import Foundation
import RxSwift

protocol UserLocalDataStore {
    func set(user: [User]) -> Single<()>
    func getUser() -> Single<[UserEntity]>
    func getAuthorToken() -> Single<String>
}

struct UserLocalDataStoreImpl: UserLocalDataStore {
    
    func set(user: [User]) -> Single<()> {
        return Single.create(subscribe: { single -> Disposable in
            AppUserDefaults.setUser(user: user)
            single(.success(()))
            return Disposables.create()
        })
    }
    
    func getUser() -> Single<[UserEntity]> {
        return Single.create(subscribe: { single -> Disposable in
            single(.success(AppUserDefaults.getUser()))
            return Disposables.create()
        })
    }
    
    func getAuthorToken() -> Single<String> {
        return Single.create(subscribe: { single -> Disposable in
            single(.success(AppUserDefaults.getAuthToken()))
            return Disposables.create()
        })
    }
}
