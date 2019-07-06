import Foundation
import RxSwift

protocol DetailLocalDataStore {
    func set(document id: String) -> Single<()>
    func set(comment id: String) -> Single<()>
    func getDocumentId() -> Single<String>
    func getDocumentIds() -> Single<(documentId: String, commentId: String)>
}

struct DetailLocalDataStoreImpl: DetailLocalDataStore {
    
    func set(document id: String) -> Single<()> {
        return Single.create(subscribe: { single -> Disposable in
            AppUserDefaults.setGoalDocument(id: id)
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
}
