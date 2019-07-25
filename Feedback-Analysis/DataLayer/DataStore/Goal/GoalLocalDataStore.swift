import Foundation
import RxSwift

protocol GoalLocalDataStore {
    func setSelected(index: Int) -> Single<()>
    func getSelected() -> Single<Int>
    func getAuthorToken() -> Single<String>
    func setGoalsAuthorTokens(_ values: [String]) -> Single<()>
    func getGoalsAuthorTokens() -> Single<[String]>
    func setCompleteAuthorTokens(_ values: [String]) -> Single<()>
    func getCompleteAuthorTokens() -> Single<[String]>
    func setFollowAuthorTokens(_ values: [String]) -> Single<()>
    func getFollowAuthorTokens() -> Single<[String]>
    func getGoalDocumentId() -> Single<String>
    func setGoalDocumentId(_ value: String) -> Single<()>
}

struct GoalLocalDataStoreImpl: GoalLocalDataStore {
    
    func setSelected(index: Int) -> Single<()> {
        return Single.create(subscribe: { single -> Disposable in
            AppUserDefaults.setSelected(index: index)
            single(.success(()))
            return Disposables.create()
        })
    }
    
    func getSelected() -> Single<Int> {
        return Single.create(subscribe: { single -> Disposable in
            single(.success(AppUserDefaults.getSelected()))
            return Disposables.create()
        })
    }
    
    func getAuthorToken() -> Single<String> {
        return Single.create(subscribe: { single -> Disposable in
            single(.success(AppUserDefaults.getAuthToken()))
            return Disposables.create()
        })
    }
    
    func setGoalsAuthorTokens(_ values: [String]) -> Single<()> {
        return Single.create(subscribe: { single -> Disposable in
            single(.success(AppUserDefaults.setGoalsAuthorTokens(authorTokens: values)))
            return Disposables.create()
        })
    }
    
    func getGoalsAuthorTokens() -> Single<[String]> {
        return Single.create(subscribe: { single -> Disposable in
            single(.success(AppUserDefaults.getGoalsAuthorTokens()))
            return Disposables.create()
        })
    }
    
    func setCompleteAuthorTokens(_ values: [String]) -> Single<()> {
        return Single.create(subscribe: { single -> Disposable in
            single(.success(AppUserDefaults.setCompleteAuthorTokens(authorTokens: values)))
            return Disposables.create()
        })
    }
    
    func getCompleteAuthorTokens() -> Single<[String]> {
        return Single.create(subscribe: { single -> Disposable in
            single(.success(AppUserDefaults.getCompleteAuthorTokens()))
            return Disposables.create()
        })
    }
    
    func setFollowAuthorTokens(_ values: [String]) -> Single<()> {
        return Single.create(subscribe: { single -> Disposable in
            single(.success(AppUserDefaults.setFollowsAuthorTokens(authorTokens: values)))
            return Disposables.create()
        })
    }
    
    func getFollowAuthorTokens() -> Single<[String]> {
        return Single.create(subscribe: { single -> Disposable in
            single(.success(AppUserDefaults.getFollowAuthorTokens()))
            return Disposables.create()
        })
    }
    
    func getGoalDocumentId() -> Single<String> {
        return Single.create(subscribe: { single -> Disposable in
            single(.success(AppUserDefaults.getGoalDocument()))
            return Disposables.create()
        })
    }
    
    func setGoalDocumentId(_ value: String) -> Single<()> {
        return Single.create(subscribe: { single -> Disposable in
            AppUserDefaults.setGoalDocument(id: value)
            single(.success(()))
            return Disposables.create()
        })
    }
}
