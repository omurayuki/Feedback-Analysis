import Foundation
import RxSwift

protocol UserLocalDataStore {
    func set(user: [User]) -> Single<()>
    func getUser() -> Single<[UserEntity]>
    func getAuthorToken() -> Single<String>
    func setObjectToken(_ token: String) -> Single<()>
    func getBothToken() -> Single<(String, String)>
    func setConversation(_ conversation: Conversation) -> Single<()>
    func getConversation() -> Single<Conversation>
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
    
    func setObjectToken(_ token: String) -> Single<()> {
        return Single.create(subscribe: { single -> Disposable in
            AppUserDefaults.setObjectToken(token: token)
            single(.success(()))
            return Disposables.create()
        })
    }
    
    func getBothToken() -> Single<(String, String)> {
        return Single.create(subscribe: { single -> Disposable in
            single(.success((AppUserDefaults.getAuthToken(), AppUserDefaults.getObjectToken())))
            return Disposables.create()
        })
    }
    
    func setConversation(_ conversation: Conversation) -> Single<()> {
        return Single.create(subscribe: { single -> Disposable in
            AppUserDefaults.setConversationInOnotherPerson(conversation: [conversation])
            single(.success(()))
            return Disposables.create()
        })
    }
    
    func getConversation() -> Single<Conversation> {
        return Single.create(subscribe: { single -> Disposable in
            if let conversation = AppUserDefaults.getConversationInOnotherPerson().first {
                single(.success(conversation))
            }
            return Disposables.create()
        })
    }
}
