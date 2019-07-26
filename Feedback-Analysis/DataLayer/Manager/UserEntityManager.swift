import Foundation
import FirebaseFirestore

struct UserEntityManager {
    
    func fetchUserEntity(documentRef: FirebaseDocumentRef,
                         completion: @escaping (_ response: FirestoreResponse<UserEntity>) -> Void) {
        Provider().get(documentRef: documentRef) { response in
            switch response {
            case .success(let entity):
                guard let data = entity.data() else { return }
                completion(.success(UserEntity(document: data)))
            case .failure(let error):
                completion(.failure(error))
            case .unknown:
                completion(.unknown)
            }
        }
    }
    
    func fetchUserFollowerEntities(queryRef: FirebaseQueryRef,
                                   completion: @escaping (_ response: FirestoreResponse<[UserEntity]>) -> Void) {
        var userEntities = [UserEntity]()
        Provider().gets(queryRef: queryRef) { response in
            switch response {
            case .success(let entities):
                entities
                    .compactMap { $0.data()["following_user_token"] as? String }
                    .forEach {
                        Provider().get(documentRef: .userRef(authorToken: $0), completion: { response in
                            switch response {
                            case .success(let entity):
                                guard let data = entity.data() else { return }
                                userEntities.append(UserEntity(document: data))
                            case .failure(let error):
                                completion(.failure(error))
                            case .unknown:
                                completion(.unknown)
                            }
                        })
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    completion(.success(userEntities))
                })
            case .failure(let error):
                completion(.failure(error))
            case .unknown:
                completion(.unknown)
            }
        }
    }
    
    func fetchUserFolloweeEntities(queryRef: FirebaseQueryRef,
                                   completion: @escaping (_ response: FirestoreResponse<[UserEntity]>) -> Void) {
        var userEntities = [UserEntity]()
        Provider().gets(queryRef: queryRef) { response in
            switch response {
            case .success(let entities):
                entities
                    .compactMap { $0.data()["follower_user_token"] as? String }
                    .forEach {
                        Provider().get(documentRef: .userRef(authorToken: $0), completion: { response in
                            switch response {
                            case .success(let entity):
                                guard let data = entity.data() else { return }
                                userEntities.append(UserEntity(document: data))
                            case .failure(let error):
                                completion(.failure(error))
                            case .unknown:
                                completion(.unknown)
                            }
                        })
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        completion(.success(userEntities))
                    })
            case .failure(let error):
                completion(.failure(error))
            case .unknown:
                completion(.unknown)
            }
        }
    }
}
