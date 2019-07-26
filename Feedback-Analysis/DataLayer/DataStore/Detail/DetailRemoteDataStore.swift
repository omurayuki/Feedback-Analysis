import Foundation
import RxSwift

protocol DetailRemoteDataStore {
    func update(to documentRef: FirebaseDocumentRef, value: [String : Any]) -> Single<()>
    func create(documentRef: FirebaseDocumentRef, value: [String: Any]) -> Single<()>
    func delete(documentRef: FirebaseDocumentRef) -> Single<()>
    func post(to documentRef: FirebaseDocumentRef, comment: CommentPost) -> Single<()>
    func post(to documentRef: FirebaseDocumentRef, reply: ReplyPost) -> Single<()>
    func get(from queryRef: FirebaseQueryRef) -> Observable<[CommentEntity]>
    func get(from queryRef: FirebaseQueryRef) -> Observable<[ReplyEntity]>
    func get(documentRef: FirebaseDocumentRef) -> Single<Bool>
}

struct DetailRemoteDataStoreImpl: DetailRemoteDataStore {
    
    func update(to documentRef: FirebaseDocumentRef, value: [String : Any]) -> Single<()> {
        return Single.create(subscribe: { single -> Disposable in
            Provider().update(documentRef: documentRef, fields: value,
                              completion: { response in
                switch response {
                case .success(_):
                    single(.success(()))
                case .failure(let error):
                    single(.error(FirebaseError.resultError(error)))
                case .unknown:
                    single(.error(FirebaseError.unknown))
                }
            })
            return Disposables.create()
        })
    }
    
    func create(documentRef: FirebaseDocumentRef, value: [String: Any]) -> Single<()> {
        return Single.create(subscribe: { single -> Disposable in
            Provider().setData(documentRef: documentRef, fields: value, completion: { response in
                switch response {
                case .success(_):
                    single(.success(()))
                case .failure(let error):
                    single(.error(FirebaseError.resultError(error)))
                case .unknown:
                    single(.error(FirebaseError.unknown))
                }
            })
            return Disposables.create()
        })

    }
    
    func delete(documentRef: FirebaseDocumentRef) -> Single<()> {
        return Single.create(subscribe: { single -> Disposable in
            Provider().delete(documentRef: documentRef, completion: { response in
                switch response {
                case .success(_):
                    single(.success(()))
                case .failure(let error):
                    single(.error(FirebaseError.resultError(error)))
                case .unknown:
                    single(.error(FirebaseError.unknown))
                }
            })
            return Disposables.create()
        })
    }
    
    func post(to documentRef: FirebaseDocumentRef, comment: CommentPost) -> Single<()> {
        return Single.create(subscribe: { single -> Disposable in
            Provider().setData(documentRef: documentRef, fields: comment.encode(), completion: { response in
                switch response {
                case .success(_):
                    single(.success(()))
                case .failure(let error):
                    single(.error(FirebaseError.resultError(error)))
                case .unknown:
                    single(.error(FirebaseError.unknown))
                }
            })
            return Disposables.create()
        })
    }
    
    func post(to documentRef: FirebaseDocumentRef, reply: ReplyPost) -> Single<()> {
        return Single.create(subscribe: { single -> Disposable in
            Provider().setData(documentRef: documentRef, fields: reply.encode(), completion: { response in
                switch response {
                case .success(_):
                    single(.success(()))
                case .failure(let error):
                    single(.error(FirebaseError.resultError(error)))
                case .unknown:
                    single(.error(FirebaseError.unknown))
                }
            })
            return Disposables.create()
        })
    }
    
    func get(from queryRef: FirebaseQueryRef) -> Observable<[CommentEntity]> {
        return Observable.create({ observer -> Disposable in
            CommentEntityManager().fetchCommentEntities(queryRef: queryRef, completion: { response in
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
        })
    }
    
    func get(from queryRef: FirebaseQueryRef) -> Observable<[ReplyEntity]> {
        return Observable.create({ observer -> Disposable in
            ReplyEntityManager().fetchReplyEntities(queryRef: queryRef, completion: { response in
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
        })
    }
    
    func get(documentRef: FirebaseDocumentRef) -> Single<Bool> {
        return Single.create(subscribe: { single -> Disposable in
            Provider().isExists(documentRef: documentRef, completion: { response in
                switch response {
                case .success(let entity):
                    single(.success(entity))
                case .failure(let error):
                    single(.error(FirebaseError.resultError(error)))
                case .unknown:
                    single(.error(FirebaseError.unknown))
                }
            })
            return Disposables.create()
        })
    }
}
