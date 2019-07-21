import Foundation
import FirebaseFirestore

struct CommentEntity: Entity {
    let documentId: String
    let user: UserEntity
    let authorToken: String
    let goalDocumentId: String
    let comment: String
    let likeCount: Int
    let repliedCount: Int
    let createdAt: Timestamp
    let updatedAt: Timestamp
    
    init(user: UserEntity, document: [String: Any], documentId: String) {
        guard
            let authorToken = document["author_token"] as? String,
            let goalDocumentId = document["goal_document_id"] as? String,
            let comment = document["comment"] as? String,
            let likeCount = document["like_count"] as? Int,
            let repliedCount = document["replied_count"] as? Int,
            let createdAt = document["created_at"] as? Timestamp,
            let updatedAt = document["updated_at"] as? Timestamp
        else {
            self.documentId = ""
            self.user = UserEntity(document: ["": ""], authorToken: "")
            self.authorToken = ""
            self.goalDocumentId = ""
            self.comment = ""
            self.likeCount = 0
            self.repliedCount = 0
            self.createdAt = Timestamp()
            self.updatedAt = Timestamp()
            return
        }
        self.documentId = documentId
        self.user = user
        self.authorToken = authorToken
        self.goalDocumentId = goalDocumentId
        self.comment = comment
        self.likeCount = likeCount
        self.repliedCount = repliedCount
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
