import Foundation
import FirebaseAuth
import Firebase
import FirebaseCore
import FirebaseStorage
import RxSwift

struct AccountEntityManager {
    
    func signup(email: String, pass: String,
                completion: @escaping (FirestoreResponse<AccountEntity>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: pass, completion: { authResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let email = authResult?.user.email, let uid = authResult?.user.uid else {
                completion(.unknown)
                return
            }
            completion(.success(AccountEntity(email: email, authToken: uid)))
        })
    }
    
    func login(email: String, pass: String,
               completion: @escaping (FirestoreResponse<AccountEntity>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: pass, completion: { authResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let email = authResult?.user.email, let uid = authResult?.user.uid else {
                completion(.unknown)
                return
            }
            completion(.success(AccountEntity(email: email, authToken: uid)))
        })
    }
    
    func logout(completion: @escaping (FirestoreResponse<()>) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(.success(()))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func update(with email: String,
                completion: @escaping (FirestoreResponse<()>) -> Void) {
        Auth.auth().currentUser?.updateEmail(to: email, completion: { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(()))
        })
    }
    
    func update(with email: String, oldPass: String, newPass: String,
                completion: @escaping (FirestoreResponse<()>) -> Void) {
        let credential = EmailAuthProvider.credential(withEmail: email, password: oldPass)
        Auth.auth().currentUser?.reauthenticate(with: credential, completion: { authResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            authResult?.user.updatePassword(to: newPass, completion: { error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                completion(.success(()))
            })
        })
    }
    
    func reissuePassword(email: String,
                         completion: @escaping (FirestoreResponse<()>) -> Void) {
        Auth.auth().languageCode = "ja"
        Auth.auth().sendPasswordReset(withEmail: email, completion: { error in
            if let error = error {
                completion(.failure(error))
            }
            completion(.success(()))
        })
    }
    
    func uploadImage(_ image: UIImage, at storageRef: FirebaseStorageRef,
                     completion: @escaping (FirestoreResponse<URL>) -> Void) {
        guard let imageData = image.pngData() else {
            completion(.unknown)
            return
        }
        storageRef
            .destination
            .putData(imageData, metadata: nil, completion: { (metadata, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                storageRef
                    .destination
                    .downloadURL(completion: { (url, error) in
                        if let error = error {
                            completion(.failure(error))
                        }
                        guard let url = url else {
                            completion(.unknown)
                            return
                        }
                        completion(.success(url))
                    })
            })
    }
}
