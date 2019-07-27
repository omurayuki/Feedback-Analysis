import Foundation
import RxSwift
import FirebaseFirestore

struct ReplyEntityManager {
    
    func fetchReplyEntities(queryRef: FirebaseQueryRef,
                              completion: @escaping (_ response: FirestoreResponse<[ReplyEntity]>) -> Void) {
        var userDocuments = [EntityType]()
        Provider().gets(queryRef: queryRef) { response in
            switch response {
            case .success(let entities):
                entities.forEach {
                    guard let token = $0.data()["author_token"] as? String else {
                        completion(.unknown)
                        return
                    }
                    Provider().observe(documentRef: .authorRef(authorToken: token),
                                       completion: { response in
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
                        ReplyEntity(user: UserEntity(document: userDocuments[index]),
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
