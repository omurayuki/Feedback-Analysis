import Foundation
import RxSwift

protocol ConversationLocalDataStore {
    func getAuthToken() -> Single<String>
}

struct ConversationLocalDataStoreImpl: ConversationLocalDataStore {
    
    func getAuthToken() -> Single<String> {
        return Single.create(subscribe: { single -> Disposable in
            single(.success(AppUserDefaults.getAuthToken()))
            return Disposables.create()
        })
    }
}
