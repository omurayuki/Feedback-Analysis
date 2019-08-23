import Foundation

struct CompleteManager {
    
    func fetchCompleteEntities(queryRef: FirebaseQueryRef,
                             completion: @escaping (_ response: FirestoreResponse<[CompleteEntity]>) -> Void) {
        Provider().observe(queryRef: queryRef, completion: { response in
            switch response {
            case .success(let completeEntities):
                completion(.success(completeEntities.compactMap { CompleteEntity(document: $0.data(), documentId: $0.documentID) }))
            case .failure(let error):
                completion(.failure(error))
            case .unknown:
                completion(.unknown)
            }
        })
    }
}
