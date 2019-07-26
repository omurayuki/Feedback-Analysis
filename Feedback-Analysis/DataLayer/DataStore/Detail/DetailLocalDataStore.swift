import Foundation
import RxSwift

protocol DetailLocalDataStore {
    func fetch() -> Single<AccountEntity>
    func set(document id: String) -> Single<()>
    func set(otherPersonAuthorFromTimelineToken token: String) -> Single<()>
    func set(otherPersonAuthorFromCommentToken token: String) -> Single<()>
    func set(comment id: String) -> Single<()>
    func getOtherPersonAuthorFromTimelineToken() -> Single<String>
    func getOtherPersonAuthorFromCommentToken() -> Single<String>
    func getDocumentId() -> Single<String>
    func getDocumentIds() -> Single<(documentId: String, commentId: String)>
    func setSelected(index: Int) -> Single<()>
    func getSelected() -> Single<Int>
}

struct DetailLocalDataStoreImpl: DetailLocalDataStore {
    
    func fetch() -> Single<AccountEntity> {
        return Single.create(subscribe: { single -> Disposable in
            single(.success(AccountEntity(email: AppUserDefaults.getAccountEmail(), authToken: AppUserDefaults.getAuthToken())))
            return Disposables.create()
        })
    }
    
    func set(document id: String) -> Single<()> {
        return Single.create(subscribe: { single -> Disposable in
            AppUserDefaults.setGoalDocument(id: id)
            single(.success(()))
            return Disposables.create()
        })
    }
    
    func set(otherPersonAuthorFromTimelineToken token: String) -> Single<()> {
        return Single.create(subscribe: { single -> Disposable in
            AppUserDefaults.setOtherPersonAuthFromTimelineToken(token: token)
            single(.success(()))
            return Disposables.create()
        })
    }
    
    func set(otherPersonAuthorFromCommentToken token: String) -> Single<()> {
        return Single.create(subscribe: { single -> Disposable in
            AppUserDefaults.setOtherPersonAuthFromCommentToken(token: token)
            single(.success(()))
            return Disposables.create()
        })
    }
    
    func set(comment id: String) -> Single<()> {
        return Single.create(subscribe: { single -> Disposable in
            AppUserDefaults.setCommentDocument(id: id)
            single(.success(()))
            return Disposables.create()
        })
    }
    
    func getOtherPersonAuthorFromTimelineToken() -> Single<String> {
        return Single.create(subscribe: { single -> Disposable in
            single(.success(AppUserDefaults.getOtherPersonAuthFromTimelineToken()))
            return Disposables.create()
        })
    }
    
    func getOtherPersonAuthorFromCommentToken() -> Single<String> {
        return Single.create(subscribe: { single -> Disposable in
            single(.success(AppUserDefaults.getOtherPersonAuthFromCommentToken()))
            return Disposables.create()
        })
    }
    
    func getDocumentId() -> Single<String> {
        return Single.create(subscribe: { single -> Disposable in
            single(.success(AppUserDefaults.getGoalDocument()))
            return Disposables.create()
        })
    }
    
    func getDocumentIds() -> Single<(documentId: String, commentId: String)> {
        return Single.create(subscribe: { single -> Disposable in
            single(.success((documentId: AppUserDefaults.getGoalDocument(),
                            commentId: AppUserDefaults.getCommentDocument())))
            return Disposables.create()
        })
    }
    
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
}
