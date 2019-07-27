import Foundation
import FirebaseFirestore
import RxSwift

class JustToBeSure {
    
    //// detailVC
//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//        presenter.getDocumentId(completion: { [unowned self] documentId in
//            self.presenter.get(from: .commentRef(goalDocument: documentId))
//        })
//    }
    
    func setData(documentRef: FirebaseDocumentRef,
                 fields: EntityType) -> Single<()> {
        return Single.create(subscribe: { single -> Disposable in
            documentRef
                .destination
                .setData(fields, completion: { error in
                    if let error = error {
                        single(.error(FirebaseError.resultError(error)))
                        return
                    }
                    single(.success(()))
                })
            return Disposables.create()
        })
    }
    
    func update(documentRef: FirebaseDocumentRef,
                fields: EntityType) -> Single<()> {
        return Single.create(subscribe: { single -> Disposable in
            documentRef
                .destination
                .updateData(fields, completion: { error in
                    if let error = error {
                        single(.error(FirebaseError.resultError(error)))
                        return
                    }
                    single(.success(()))
                })
            return Disposables.create()
        })
    }
    
    func delete(documentRef: FirebaseDocumentRef) -> Single<()> {
        return Single.create(subscribe: { single -> Disposable in
            documentRef
                .destination
                .delete(completion: { error in
                    if let error = error {
                        single(.error(FirebaseError.resultError(error)))
                        return
                    }
                    single(.success(()))
                })
            return Disposables.create()
        })
    }
    
    func observeQuery(queryRef: FirebaseQueryRef) -> Observable<[CommentEntity]> {
        var userDocuments = [[String: Any]]()
        return Observable.create({ observer -> Disposable in
            queryRef
                .destination
                .addSnapshotListener({ commentSnapshot, error in
                    if let error = error {
                        observer.on(.error(FirebaseError.resultError(error)))
                        return
                    }
                    guard let documents = commentSnapshot?.documents else {
                        observer.on(.error(FirebaseError.unknown))
                        return
                    }
                    documents.forEach {
                        guard let token = $0.data()["author_token"] as? String else {
                            observer.on(.error(FirebaseError.unknown))
                            return
                        }
                        FirebaseDocumentRef
                            .authorRef(authorToken: token)
                            .destination
                            .addSnapshotListener({ snapshot, error in
                                if let error = error {
                                    observer.on(.error(FirebaseError.resultError(error)))
                                    return
                                }
                                guard let Document = snapshot?.data() else {
                                    observer.on(.error(FirebaseError.unknown))
                                    return
                                }
                                userDocuments.append(Document)
                            })
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7, execute: {
                        observer.on(.next(documents.enumerated().compactMap { index, data in
                            CommentEntity(user: UserEntity(document: userDocuments[index]),
                                          document: data.data(), documentId: data.documentID)
                        }))
                    })
                })
            return Disposables.create()
        })
    }
    
    func observeQuery(queryRef: FirebaseQueryRef) -> Observable<[ReplyEntity]> {
        var userDocuments = [[String: Any]]()
        return Observable.create({ observer -> Disposable in
            queryRef
                .destination
                .addSnapshotListener({ commentSnapshot, error in
                    if let error = error {
                        observer.on(.error(FirebaseError.resultError(error)))
                        return
                    }
                    guard let documents = commentSnapshot?.documents else {
                        observer.on(.error(FirebaseError.unknown))
                        return
                    }
                    documents.forEach {
                        guard let token = $0.data()["author_token"] as? String else {
                            observer.on(.error(FirebaseError.unknown))
                            return
                        }
                        FirebaseDocumentRef
                            .authorRef(authorToken: token)
                            .destination
                            .addSnapshotListener({ userSnapshot, errorq in
                                if let error = error {
                                    observer.on(.error(FirebaseError.resultError(error)))
                                    return
                                }
                                guard let userDocument = userSnapshot?.data() else {
                                    observer.on(.error(FirebaseError.unknown))
                                    return
                                }
                                userDocuments.append(userDocument)
                            })
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7, execute: {
                        observer.on(.next(documents.enumerated().compactMap { index, data in
                            ReplyEntity(user: UserEntity(document: userDocuments[index]),
                                        document: data.data(), documentId: data.documentID)
                        }))
                    })
                })
            return Disposables.create()
        })
    }
    
    func observeTimeline(queryRef: FirebaseQueryRef) -> Observable<[GoalEntity]> {
        var userDocuments = [[String: Any]]()
        return Observable.create({ observer -> Disposable in
            queryRef
                .destination
                .getDocuments(completion: { commentSnapshot, error in
                    if let error = error {
                        observer.on(.error(FirebaseError.resultError(error)))
                        return
                    }
                    guard let documents = commentSnapshot?.documents else {
                        observer.on(.error(FirebaseError.unknown))
                        return
                    }
                    documents.forEach {
                        guard let token = $0.data()["author_token"] as? String else {
                            observer.on(.error(FirebaseError.unknown))
                            return
                        }
                        FirebaseDocumentRef
                            .authorRef(authorToken: token)
                            .destination
                            .addSnapshotListener({ userSnapshot, error in
                                if let error = error {
                                    observer.on(.error(FirebaseError.resultError(error)))
                                    return
                                }
                                guard let userDocument = userSnapshot?.data() else {
                                    observer.on(.error(FirebaseError.unknown))
                                    return
                                }
                                userDocuments.append(userDocument)
                            })
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7, execute: {
                        observer.on(.next(documents.enumerated().compactMap { index, data in
                            GoalEntity(user: UserEntity(document: userDocuments[index]),
                                       document: data.data(), documentId: data.documentID)
                        }))
                    })
                })
            return Disposables.create()
        })
    }
    
    func getUserFollowerEntities(queryRef: FirebaseQueryRef) -> Single<[UserEntity]> {
        return Single.create { single -> Disposable in
            var userEntities = [UserEntity]()
            queryRef
                .destination
                .getDocuments(completion: { snapshot, error in
                    if let error = error {
                        single(.error(FirebaseError.resultError(error)))
                        return
                    }
                    guard let snapshots = snapshot?.documents else {
                        return
                    }
                    snapshots
                        .compactMap { $0.data()["following_user_token"] as? String }
                        .forEach {
                            FirebaseDocumentRef
                                .userRef(authorToken: $0)
                                .destination
                                .getDocument(completion: { snapshot, error in
                                    if let error = error {
                                        single(.error(FirebaseError.resultError(error)))
                                    }
                                    guard let snapshot = snapshot, snapshot.exists else {
                                        single(.error(FirebaseError.unknown))
                                        return
                                    }
                                    guard let documentData = snapshot.data() else {
                                        single(.error(FirebaseError.unknown))
                                        return
                                    }
                                    userEntities.append(UserEntity(document: documentData))
                                })
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        single(.success(userEntities))
                    })
                })
            return Disposables.create()
        }
    }
    
    func getUserFolloweeEntities(queryRef: FirebaseQueryRef) -> Single<[UserEntity]> {
        return Single.create { single -> Disposable in
            var userEntities = [UserEntity]()
            queryRef
                .destination
                .getDocuments(completion: { snapshot, error in
                    if let error = error {
                        single(.error(FirebaseError.resultError(error)))
                        return
                    }
                    guard let snapshots = snapshot?.documents else {
                        return
                    }
                    snapshots
                        .compactMap { $0.data()["follower_user_token"] as? String }
                        .forEach {
                            FirebaseDocumentRef
                                .userRef(authorToken: $0)
                                .destination
                                .getDocument(completion: { snapshot, error in
                                    if let error = error {
                                        single(.error(FirebaseError.resultError(error)))
                                    }
                                    guard let snapshot = snapshot, snapshot.exists else {
                                        single(.error(FirebaseError.unknown))
                                        return
                                    }
                                    guard let documentData = snapshot.data() else {
                                        single(.error(FirebaseError.unknown))
                                        return
                                    }
                                    userEntities.append(UserEntity(document: documentData))
                                })
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        single(.success(userEntities))
                    })
                })
            return Disposables.create()
        }
    }
}
