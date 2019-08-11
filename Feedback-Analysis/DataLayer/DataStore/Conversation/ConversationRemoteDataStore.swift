import Foundation
import RxSwift

protocol ConversationRemoteDataStore {
    func fetchConversations(from queryRef: FirebaseQueryRef) -> Observable<[ConversationEntity]>
    func markAsRead(conversation: Conversation) -> Single<()>
    func fetchMessages(queryRef: FirebaseQueryRef) -> Observable<[MessageEntity]>
}

struct ConversationRemoteDataStoreImpl: ConversationRemoteDataStore {
    
    func fetchConversations(from queryRef: FirebaseQueryRef) -> Observable<[ConversationEntity]> {
        return Observable.create { observer -> Disposable in
            ConversationManager().observeConversationEntities(queryRef: queryRef, completion: { response in
                switch response {
                case .success(let entities):
                    observer.on(.next(entities))
                case .failure(let error):
                    observer.on(.error(FirebaseError.resultError(error)))
                case .unknown:
                    observer.on(.error(FirebaseError.unknown))
                }
            })
            return Disposables.create()
        }
    }
    
    func markAsRead(conversation: Conversation) -> Single<()> {
        return Single.create(subscribe: { single -> Disposable in
            ConversationManager().markAsRead(conversation, completion: { response in
                switch response {
                case .success(_):
                    single(.success(()))
                case .failure(let error):
                    single(.error((FirebaseError.resultError(error))))
                case .unknown:
                    single(.error(FirebaseError.unknown))
                }
            })
            return Disposables.create()
        })
    }
    
    func fetchMessages(queryRef: FirebaseQueryRef) -> Observable<[MessageEntity]> {
        return Observable.create{ observer -> Disposable in
            MessageManager().fetchMessageEntities(queryRef: queryRef, completion: { response in
                switch response {
                case .success(let entities):
                    observer.on(.next(entities))
                case .failure(let error):
                    observer.on(.error(FirebaseError.resultError(error)))
                case .unknown:
                    observer.on(.error(FirebaseError.unknown))
                }
            })
            return Disposables.create()
        }
    }
}
