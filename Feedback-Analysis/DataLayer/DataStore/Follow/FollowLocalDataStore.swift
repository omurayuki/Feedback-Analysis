import Foundation
import RxSwift

protocol FollowLocalDataStore {
    func setAuthorTokens(_ values: [String]) -> Single<()>
    func getAuthorToken(_ index: Int) -> Single<String>
}

struct FollowLocalDataStoreImpl: FollowLocalDataStore {
    
    func setAuthorTokens(_ values: [String]) -> Single<()> {
        return Single.create(subscribe: { single -> Disposable in
            return Disposables.create()
        })
    }
    
    func getAuthorToken(_ index: Int) -> Single<String> {
        return Single.create(subscribe: { single -> Disposable in
            return Disposables.create()
        })
    }
}
