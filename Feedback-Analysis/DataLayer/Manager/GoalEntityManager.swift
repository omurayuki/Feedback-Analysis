import Foundation
import FirebaseFirestore

struct GoalEntityManager {
    
    func fetchMypageEntities(queryRef: FirebaseQueryRef, authorToken: String,
                             completion: @escaping (_ response: FirestoreResponse<[GoalEntity]>) -> Void) {
            Provider().observe(queryRef: queryRef, completion: { response in
                switch response {
                case .success(let goalEntities):
                    goalEntities.forEach { goal in
                        Provider().observe(documentRef: .userRef(authorToken: authorToken),
                                           completion: { response in
                            switch response {
                            case .success(let userEntity):
                                guard let userEntity = userEntity.data() else { return }
                                completion(.success(goalEntities.compactMap { GoalEntity(user: UserEntity(document: userEntity),
                                                                                         document: $0.data(),
                                                                                         documentId: $0.documentID) }))
                            case .failure(let error):
                                completion(.failure(error))
                            case .unknown:
                                completion(.unknown)
                            }
                        })
                    }
                case .failure(let error):
                   completion(.failure(error))
                case .unknown:
                    completion(.unknown)
                }
            })
    }
    
    func fetchTimelineEntities(queryRef: FirebaseQueryRef,
                     completion: @escaping (_ response: FirestoreResponse<[GoalEntity]>) -> Void) {
        var userDocuments = [EntityType]()
        Provider().gets(queryRef: queryRef) { response in
            switch response {
            case .success(let entities):
                entities.forEach {
                    guard let token = $0.data()["author_token"] as? String else {
                        completion(.unknown)
                        return
                    }
                    Provider().observe(documentRef: .authorRef(authorToken: token), completion: { response in
                        switch response {
                        case .success(let entity):
                            guard let data = entity.data() else { return }
                            userDocuments.append(data)
                        case .failure(let error):
                            completion(.failure(error))
                        case .unknown:
                            completion(.unknown)
                        }
                    })
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7, execute: {
                    completion(.success(entities.enumerated().compactMap { index, data in
                        GoalEntity(user: UserEntity(document: userDocuments[index]),
                                   document: data.data(),
                                   documentId: data.documentID)
                    }))
                })
            case .failure(let error):
                completion(.failure(error))
            case .unknown:
                completion(.unknown)
            }
        }
    }
}
