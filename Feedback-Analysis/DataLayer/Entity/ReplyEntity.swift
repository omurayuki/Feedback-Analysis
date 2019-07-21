import Foundation
import FirebaseFirestore

struct ReplyEntity: Entity {
    let documentId: String
    let user: UserEntity
    let authorToken: String
    let reply: String
    let createdAt: Timestamp
    let updatedAt: Timestamp
    
    init(user: UserEntity, document: [String: Any], documentId: String) {
        guard
            let authorToken = document["author_token"] as? String,
            let reply = document["reply"] as? String,
            let createdAt = document["created_at"] as? Timestamp,
            let updatedAt = document["updated_at"] as? Timestamp
            else {
                self.documentId = ""
                self.user = UserEntity(document: ["": ""], authorToken: "")
                self.authorToken = ""
                self.reply = ""
                self.createdAt = Timestamp()
                self.updatedAt = Timestamp()
                return
        }
        self.documentId = documentId
        self.user = user
        self.authorToken = authorToken
        self.reply = reply
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
