import Foundation
import FirebaseAuth
import Firebase
import FirebaseFirestore
import FirebaseCore
import FirebaseAuth
import FirebaseStorage
import RxSwift

struct Provider {
    
    func signup(email: String, pass: String) -> Single<AccountEntity> {
        return Single.create(subscribe: { single -> Disposable in
            Auth.auth().createUser(withEmail: email, password: pass, completion: { authResult, error in
                if let error = error {
                    single(.error(FirebaseError.resultError(error)))
                    return
                }
                guard let email = authResult?.user.email, let uid = authResult?.user.uid else {
                    single(.error(FirebaseError.unknown))
                    return
                }
                single(.success(AccountEntity(email: email, authToken: uid)))

            })
            return Disposables.create()
        })
    }
    
    func login(email: String, pass: String) -> Single<AccountEntity> {
        return Single.create(subscribe: { single -> Disposable in
            Auth.auth().signIn(withEmail: email, password: pass, completion: { authResult, error in
                if let error = error {
                    single(.error(FirebaseError.resultError(error)))
                    return
                }
                guard let email = authResult?.user.email, let uid = authResult?.user.uid else {
                    single(.error(FirebaseError.unknown))
                    return
                }
                single(.success(AccountEntity(email: email, authToken: uid)))
            })
            return Disposables.create()
        })
    }
    
    func logout() -> Single<()> {
        return Single.create(subscribe: { single -> Disposable in
            do {
                try Auth.auth().signOut()
                single(.success(()))
            } catch let error {
                single(.error(FirebaseError.resultError(error)))
            }
            return Disposables.create()
        })
    }
    
    func update(with email: String) -> Single<()> {
        return Single.create(subscribe: { single -> Disposable in
            Auth.auth().currentUser?.updateEmail(to: email, completion: { error in
                if let error = error {
                    single(.error(FirebaseError.resultError(error)))
                    return
                }
                single(.success(()))
            })
            return Disposables.create()
        })
    }
    
    func update(with email: String, oldPass: String, newPass: String) -> Single<()> {
        return Single.create(subscribe: { single -> Disposable in
            let credential = EmailAuthProvider.credential(withEmail: email, password: oldPass)
            Auth.auth().currentUser?.reauthenticate(with: credential, completion: { authResult, error in
                if let error = error {
                    single(.error(FirebaseError.resultError(error)))
                    return
                }
                authResult?.user.updatePassword(to: newPass, completion: { error in
                    if let error = error {
                        single(.error(FirebaseError.resultError(error)))
                        return
                    }
                    single(.success(()))
                })
            })
            return Disposables.create()
        })
    }
    
    func reissuePassword(email: String) -> Single<()> {
        return Single.create(subscribe: { single -> Disposable in
            Auth.auth().languageCode = "ja"
            Auth.auth().sendPasswordReset(withEmail: email, completion: { error in
                if let error = error {
                    single(.error(FirebaseError.resultError(error)))
                }
                single(.success(()))
            })
            return Disposables.create()
        })
    }
    
    func uploadImage(_ image: UIImage, at storageRef: FirebaseStorageRef) -> Single<URL> {
        return Single.create(subscribe: { single -> Disposable in
            guard let imageData = image.pngData() else {
                return Disposables.create()
            }
            storageRef
                .destination
                .putData(imageData, metadata: nil, completion: { (metadata, error) in
                if let error = error {
                    single(.error(FirebaseError.resultError(error)))
                    return
                }
                storageRef
                    .destination
                    .downloadURL(completion: { (url, error) in
                    if let error = error {
                        single(.error(FirebaseError.resultError(error)))
                    }
                    guard let url = url else {
                        single(.error(FirebaseError.unknown))
                        return
                    }
                    single(.success(url))
                })
            })
            return Disposables.create()
        })
    }
    
    func setData(documentRef: FirebaseDocumentRef,
                 fields: [String: Any]) -> Single<()> {
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
                fields: [String: Any]) -> Single<()> {
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
    
    func get(documentRef: FirebaseDocumentRef) -> Single<[String: Any]> {
        return Single.create(subscribe: { single -> Disposable in
            documentRef
                .destination
                .getDocument(completion: { snapshot, error in
                    if let error = error {
                        single(.error(FirebaseError.resultError(error)))
                        return
                    }
                    guard let snapshot = snapshot, snapshot.exists else {
                        single(.error(FirebaseError.unknown))
                        return
                    }
                    guard let documentData = snapshot.data() else {
                        single(.error(FirebaseError.unknown))
                        return
                    }
                    single(.success(documentData))
            })
            return Disposables.create()
        })
    }
    
    func observe(documentRef: DocumentReference) -> Observable<[String: Any]> {
        return Observable.create({ observer -> Disposable in
            documentRef.addSnapshotListener({ snapshot, error in
                if let error = error {
                    observer.on(.error(FirebaseError.resultError(error)))
                    return
                }
                guard let document = snapshot?.data() else {
                    observer.on(.error(FirebaseError.unknown))
                    return
                }
                observer.on(.next(document))
            })
            return Disposables.create()
        })
    }
    
    func observeQuery(queryRef: FirebaseQueryRef) -> Observable<[GoalEntity]> {
        return Observable.create({ observer -> Disposable in
            queryRef
                .destination
                .addSnapshotListener({ goalsSnapshot, error in
                    if let error = error {
                        observer.on(.error(FirebaseError.resultError(error)))
                        return
                    }
                    FirebaseDocumentRef
                        .userRef
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
                            guard let documents = goalsSnapshot?.documents else {
                                observer.on(.error(FirebaseError.unknown))
                                return
                            }
                            observer.on(.next(documents.compactMap { GoalEntity(user: UserEntity(document: userDocument),
                                                                                document: $0.data(),
                                                                                documentId: $0.documentID) }))
                        })
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
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                        observer.on(.next(documents.enumerated().compactMap { index, data in
                            CommentEntity(user: UserEntity(document: userDocuments[index]),
                                          document: data.data())
                            
                        }))
                    })
                })
            return Disposables.create()
        })
    }
}
