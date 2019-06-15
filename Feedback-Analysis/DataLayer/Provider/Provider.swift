import Foundation
import FirebaseAuth
import Firebase
import FirebaseFirestore
import FirebaseCore
import FirebaseAuth
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
}
