import Foundation
import FirebaseFirestore

struct MessageManager {
    
    func fetchMessageEntities(queryRef: FirebaseQueryRef,
                                   completion: @escaping (_ response: FirestoreResponse<[Message]>) -> Void) {
        Provider().observe(queryRef: queryRef) { response in
            switch response {
            case .success(let entities):
                let messageEntity = entities.compactMap { value  -> MessageEntity in
                    return MessageEntity(document: value.data())
                    
                }
                completion(.success(messageEntity.compactMap {
                    return Message(entity: $0)
                } ))
            case .failure(let error):
                completion(.failure(error))
            case .unknown:
                completion(.unknown)
            }
        }
    }
    
    func create(documentRef: FirebaseDocumentRef, message: Message, conversation: Conversation,
                completion: @escaping (_ response: FirestoreResponse<()>) -> Void) {
        UploadImageManager().upload(message, reference: .messages) { response in
            switch response {
            case .success(let uploadedMessage):
                let data = ["id": uploadedMessage.id , "message": uploadedMessage.message ?? "", "content": uploadedMessage.content ?? "",
                            "contentType": uploadedMessage.contentType.rawValue ?? 0, "created_at": uploadedMessage.time , "ownerID": uploadedMessage.ownerID ?? "",
                            "profilePickLink": uploadedMessage.profilePicLink ?? ""] as [String : Any]
                Provider().setData(documentRef: documentRef, fields: data, completion: { response in
                    switch response {
                    case .success(let response):
                        completion(.success(response))
                        if let id = conversation.isRead.filter({ $0.key != AppUserDefaults.getAuthToken() }).first {
//                            conversation.isRead[id.key] = false
                        }
//                        ConversationManager().create(conversation)
                    case .failure(let error):
                        completion(.failure(error))
                    case .unknown:
                        completion(.unknown)
                    }
                })
            case .failure(let error):
                completion(.failure(error))
            case .unknown:
                completion(.unknown)
            }
        }
    }
}
