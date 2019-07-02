import Foundation
import FirebaseFirestore

struct CommentEntity: Entity {
    let user: UserEntity
    let authorToken: String
    let comment: String
    let likeCount: Int
    let repliedCount: Int
    let createdAt: Timestamp
    let updatedAt: Timestamp
    
    init(user: UserEntity, document: [String: Any]) {
        guard
            let authorToken = document["author_token"] as? String,
            let comment = document["comment"] as? String,
            let likeCount = document["like_count"] as? Int,
            let repliedCount = document["replied_count"] as? Int,
            let createdAt = document["created_at"] as? Timestamp,
            let updatedAt = document["updated_at"] as? Timestamp
        else {
            self.user = UserEntity(document: ["": ""])
            self.authorToken = ""
            self.comment = ""
            self.likeCount = 0
            self.repliedCount = 0
            self.createdAt = Timestamp()
            self.updatedAt = Timestamp()
            return
        }
        self.user = user
        self.authorToken = authorToken
        self.comment = comment
        self.likeCount = likeCount
        self.repliedCount = repliedCount
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
