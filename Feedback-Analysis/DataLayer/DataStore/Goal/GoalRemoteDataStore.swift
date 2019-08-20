import Foundation
import RxSwift

protocol GoalRemoteDataStore {
    func post(to documentRef: FirebaseDocumentRef, fields: GoalPost) -> Single<()>
    func update(to documentRef: FirebaseDocumentRef, fields: GoalPost) -> Single<()>
    func fetch(from queryRef: FirebaseQueryRef, authorToken: String) -> Observable<[GoalEntity]>
    func fetch(timeline queryRef: FirebaseQueryRef) -> Observable<[GoalEntity]>
    func update(to documentRef: FirebaseDocumentRef, value: [String : Any]) -> Single<()>
    func get(documentRef: FirebaseDocumentRef) -> Single<Bool>
    func create(documentRef: FirebaseDocumentRef, value: [String: Any]) -> Single<()>
    func delete(documentRef: FirebaseDocumentRef) -> Single<()>
    func fetchCompletes(queryRef: FirebaseQueryRef) -> Single<[Complete]>
}

struct GoalRemoteDataStoreImpl: GoalRemoteDataStore {
    
    func post(to documentRef: FirebaseDocumentRef, fields: GoalPost) -> Single<()> {
        return Single.create(subscribe: { single -> Disposable in
            Provider().setData(documentRef: documentRef, fields: fields.encode(), completion: { response in
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
    
    func update(to documentRef: FirebaseDocumentRef, fields: GoalPost) -> Single<()> {
        return Single.create(subscribe: { single -> Disposable in
            Provider().update(documentRef: documentRef, fields: fields.encode(),
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
    
    func fetch(from queryRef: FirebaseQueryRef, authorToken: String) -> Observable<[GoalEntity]> {
        return Observable.create({ observer -> Disposable in
            GoalEntityManager().fetchMypageEntities(queryRef: queryRef, authorToken: authorToken) { response in
                switch response {
                case .success(let entities):
                    observer.on(.next(entities))
                case .failure(let error):
                    observer.on(.error(FirebaseError.resultError(error)))
                case .unknown:
                    observer.on(.error(FirebaseError.unknown))
                }
            }
            return Disposables.create()
        })
    }
    
    func fetch(timeline queryRef: FirebaseQueryRef) -> Observable<[GoalEntity]> {
        return Observable.create({ observer -> Disposable in
            GoalEntityManager().fetchTimelineEntities(queryRef: queryRef) { response in
                switch response {
                case .success(let entities):
                    observer.on(.next(entities))
                case .failure(let error):
                    observer.on(.error(FirebaseError.resultError(error)))
                case .unknown:
                    observer.on(.error(FirebaseError.unknown))
                }
            }
            return Disposables.create()
        })
    }
    
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
    
    func fetchCompletes(queryRef: FirebaseQueryRef) -> Single<[Complete]> {
        return Single.create(subscribe: { single -> Disposable in
            single(.success([
                 Complete(achoevement: ["hoge", "fuga"], analysis: ["分析", "分析"], strength: "特質系", goalDocumentId: "fdopfk", documentId: "fopskf", time: "10:10"),
                 Complete(achoevement: ["hoge", "fuga"], analysis: ["分析", "分析"], strength: "強化系", goalDocumentId: "fdopfk", documentId: "fopskf", time: "10:10"),
                 Complete(achoevement: ["hoge", "fuga"], analysis: ["分析", "分析"], strength: "特質系", goalDocumentId: "fdopfk", documentId: "fopskf", time: "10:10"),
                 Complete(achoevement: ["hoge", "fuga"], analysis: ["分析", "分析"], strength: "特質系", goalDocumentId: "fdopfk", documentId: "fopskf", time: "10:10"),
                 Complete(achoevement: ["hoge", "fuga"], analysis: ["分析", "分析"], strength: "変化系", goalDocumentId: "fdopfk", documentId: "fopskf", time: "10:10"),
                 Complete(achoevement: ["hoge", "fuga"], analysis: ["分析", "分析"], strength: "特質系", goalDocumentId: "fdopfk", documentId: "fopskf", time: "10:10"),
                 Complete(achoevement: ["hoge", "fuga"], analysis: ["分析", "分析"], strength: "特質系", goalDocumentId: "fdopfk", documentId: "fopskf", time: "10:10"),
                 Complete(achoevement: ["hoge", "fuga"], analysis: ["分析", "分析"], strength: "具現化系", goalDocumentId: "fdopfk", documentId: "fopskf", time: "10:10"),
                 Complete(achoevement: ["hoge", "fuga"], analysis: ["分析", "分析"], strength: "操作系", goalDocumentId: "fdopfk", documentId: "fopskf", time: "10:10")]))
            return Disposables.create()
        })
    }
}
