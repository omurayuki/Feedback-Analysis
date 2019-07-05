import Foundation
import RxSwift

protocol DetailLocalDataStore {
    func set(document id: String) -> Single<()>
    func getDocumentId() -> Single<String>
}

struct DetailLocalDataStoreImpl: DetailLocalDataStore {
    
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
