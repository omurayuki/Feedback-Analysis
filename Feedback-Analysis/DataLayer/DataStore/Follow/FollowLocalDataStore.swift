import Foundation
import RxSwift

protocol FollowLocalDataStore {
    func setFolloweeTokens(_ values: [String]) -> Single<()>
    func setFollowerTokens(_ values: [String]) -> Single<()>
    func getFolloweeToken() -> Single<[String]>
    func getFollowerToken() -> Single<[String]>
    func setObjectToken(_ value: String) -> Single<()>
    func getObjectToken() -> Single<String>
}

struct FollowLocalDataStoreImpl: FollowLocalDataStore {
    
    func setFolloweeTokens(_ values: [String]) -> Single<()> {
        return Single.create(subscribe: { single -> Disposable in
            single(.success(AppUserDefaults.setFolloweeListAuthorTokens(authorTokens: values)))
            return Disposables.create()
        })
    }
    
    func setFollowerTokens(_ values: [String]) -> Single<()> {
        return Single.create(subscribe: { single -> Disposable in
            single(.success(AppUserDefaults.setFollowerListAuthorTokens(authorTokens: values)))
            return Disposables.create()
        })
    }
    
    func getFolloweeToken() -> Single<[String]> {
        return Single.create(subscribe: { single -> Disposable in
            single(.success(AppUserDefaults.getFolloweeListAuthorTokens()))
            return Disposables.create()
        })
    }
    
    func getFollowerToken() -> Single<[String]> {
        return Single.create(subscribe: { single -> Disposable in
            single(.success(AppUserDefaults.getFollowerListAuthorTokens()))
            return Disposables.create()
        })
    }
    
    func setObjectToken(_ value: String) -> Single<()> {
        return Single.create(subscribe: { single -> Disposable in
            AppUserDefaults.setObjectToken(token: value)
            single(.success(()))
            return Disposables.create()
        })
    }
    
    func getObjectToken() -> Single<String> {
        return Single.create(subscribe: { single -> Disposable in
            single(.success(AppUserDefaults.getObjectToken()))
            return Disposables.create()
        })
    }
}
