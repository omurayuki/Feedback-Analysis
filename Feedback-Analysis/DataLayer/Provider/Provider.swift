import Foundation
import Firebase
import FirebaseFirestore
import FirebaseCore
import FirebaseStorage
import RxSwift

typealias EntityType = [String: Any]

struct Provider {
    
    func setData(documentRef: FirebaseDocumentRef, fields: EntityType,
                 completion: @escaping (_ response: FirestoreResponse<()>) -> Void) {
        documentRef.destination.setData(fields, completion: { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(()))
        })
    }
    
    func update(documentRef: FirebaseDocumentRef, fields: EntityType,
                completion: @escaping (_ response: FirestoreResponse<()>) -> Void) {
        documentRef.destination.updateData(fields, completion: { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(()))
        })
    }
    
    func delete(documentRef: FirebaseDocumentRef,
                completion: @escaping (_ response: FirestoreResponse<()>) -> Void) {
        documentRef.destination.delete(completion: { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(()))
        })
    }
    
    func isExists(documentRef: FirebaseDocumentRef,
                  completion: @escaping (_ response: FirestoreResponse<Bool>) -> Void) {
        documentRef.destination.getDocument { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let bool = snapshot?.exists else {
                completion(.unknown)
                return
            }
            completion(.success(bool))
        }
    }
    
    func get(documentRef: FirebaseDocumentRef,
             completion: @escaping (_ response: FirestoreResponse<DocumentSnapshot>) -> Void) {
            documentRef.destination.getDocument { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let snapshot = snapshot, snapshot.exists else {
                    completion(.unknown)
                    return
                }
                completion(.success(snapshot))
            }
    }
    
    func gets(queryRef: FirebaseQueryRef,
              completion: @escaping (_ response: FirestoreResponse<[QueryDocumentSnapshot]>) -> Void) {
        queryRef.destination.getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let documents = snapshot?.documents else {
                return
            }
            completion(.success(documents))
        }
    }
    
    func observe(queryRef: FirebaseQueryRef,
                 completion: @escaping (_ response: FirestoreResponse<[QueryDocumentSnapshot]>) -> Void) {
        queryRef.destination.addSnapshotListener { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let documents = snapshot?.documents else {
                completion(.unknown)
                return
            }
            completion(.success(documents))
        }
    }
    
    func observe(documentRef: FirebaseDocumentRef,
                 completion: @escaping (_ response: FirestoreResponse<DocumentSnapshot>) -> Void) {
        documentRef.destination.addSnapshotListener { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let documents = snapshot else {
                completion(.unknown)
                return
            }
            completion(.success(documents))
        }
    }
    
    //// マイページの場合これを使ってもいいが、タイムラインの場合これを使うと名前とイメージが全て同一人物になる
    func observeQuery(queryRef: FirebaseQueryRef, authorToken: String) -> Observable<[GoalEntity]> {
        return Observable.create({ observer -> Disposable in
            queryRef
                .destination
                .addSnapshotListener({ goalsSnapshot, error in
                    if let error = error {
                        observer.on(.error(FirebaseError.resultError(error)))
                        return
                    }
                    FirebaseDocumentRef
                        .userRef(authorToken: authorToken)
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
}
