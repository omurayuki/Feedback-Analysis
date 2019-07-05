import Foundation
import RxSwift

protocol GoalLocalDataStore {
    func setSelected(index: Int) -> Single<()>
    func getSelected() -> Single<Int>
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
}
