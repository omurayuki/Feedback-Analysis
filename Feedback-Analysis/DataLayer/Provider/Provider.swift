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
        documentRef.destination.setData(fields, merge: true, completion: { error in
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
}
